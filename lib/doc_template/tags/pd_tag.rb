# frozen_string_literal: true

module DocTemplate
  module Tags
    class PdTag < BaseTag
      CG_RE = %r{/content_guides/(\d+)/}i
      PDF_HTTP_RE = %r{^https?://}i
      PDF_HTTP_REPLACE_RE = /^http:/i
      PDF_RE = /\.pdf$/i
      TAG_NAME = 'pd'
      TEMPLATE = 'pd.html.erb'
      TYPE_CG = 'cg'
      TYPE_PDF = 'pdf'
      TYPE_PODCAST = 'podcast'
      TYPE_YOUTUBE = 'youtube'

      def parse(node, opts = {})
        @opts = opts
        @url, @title, @description, @start, @stop = opts[:value].split(';').map(&:strip)

        unless (embeded = fetch_data)
          node.remove
          return self
        end

        params = {
          description: description,
          start: start,
          stop: stop,
          subject: subject,
          title: title
        }.merge(embeded)
        @content = parse_template params, TEMPLATE
        replace_tag node
        self
      end

      private

      attr_reader :description, :opts, :start, :stop, :subject, :title, :url

      def embeded_object
        if url.index('soundcloud.com')
          embeded_object_soundcloud
        elsif url.index('youtube.com') || url.index('youtu.be')
          embeded_object_youtube
        elsif (id = url.scan(CG_RE).flatten.first)
          embeded_object_cg(id)
        elsif url =~ PDF_RE
          embeded_object_pdf
        end
      end

      def embeded_object_cg(id)
        return unless (cg = ContentGuide.find_by(permalink: id) || ContentGuide.find(id))

        @description = @title.presence || cg.description
        @title = cg.title

        grade = cg.grades.list.first.presence
        grade = cg.grades.grade_abbr(grade).presence || 'base'

        uri = URI.parse(url)
        cg_url = uri.path
        cg_url += "##{uri.fragment}" unless uri.fragment.blank?

        {
          color: "#{cg.subject}-#{grade}",
          content_guide: cg,
          type: TYPE_CG,
          url: cg_url
        }
      end

      def embeded_object_pdf
        pdf_url = PDF_HTTP_RE =~ url ? url : "https://#{url}"
        pdf_url = pdf_url.sub(PDF_HTTP_REPLACE_RE, 'https:')
        {
          url: pdf_url,
          type: TYPE_PDF
        }
      end

      def embeded_object_soundcloud
        {
          content: MediaEmbed.soundcloud(url, subject),
          type: TYPE_PODCAST
        }
      end

      def embeded_object_youtube
        query = {}.tap do |q|
          q[:start] = start if start.present?
          q[:end] = stop if stop.present?
        end.compact
        youtube_url = "https://www.youtube.com/embed/#{MediaEmbed.video_id(url)}?#{query.to_query}"
        {
          url: youtube_url,
          type: TYPE_YOUTUBE
        }
      end

      def fetch_data
        if (title.blank? || description.blank?) && (resource = Resource.find_by url: url)
          @title = resource.title if title.blank?
          @description = resource.teaser if description.blank?
        end

        @subject = opts[:metadata].resource_subject
        embeded_object
      end
    end
  end

  Template.register_tag(Tags::PdTag::TAG_NAME, Tags::PdTag)
end
