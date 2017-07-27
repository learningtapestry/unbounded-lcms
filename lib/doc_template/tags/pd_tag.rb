module DocTemplate
  module Tags
    class PdTag < BaseTag
      TAG_NAME = 'pd'.freeze
      TEMPLATE = 'pd.html.erb'.freeze
      TYPE_PODCAST = 'podcast'.freeze
      TYPE_YOUTUBE = 'youtube'.freeze

      def parse(node, opts = {})
        @opts = opts
        url, @title, @description = @opts[:value].split(';').map(&:strip)



        unless (embeded = fetch_data_for url)
          node.remove
          return self
        end

        params = {
          content: embeded[:content],
          description: @description,
          subject: @subject,
          title: @title,
          type: embeded[:type]
        }
        @content = parse_template params, TEMPLATE
        replace_tag node
        self
      end

      private

      def embeded_object_for(url, subject)
        if url.index('soundcloud.com')
          {
            content: MediaEmbed.soundcloud(url, subject),
            type: TYPE_PODCAST
          }
        elsif url.index('youtube.com')
          video_id = MediaEmbed.video_id(url)
          {
            content: "https://www.youtube.com/embed/#{video_id}",
            type: TYPE_YOUTUBE
          }
        end
      end

      def fetch_data_for(url)
        if (@title.blank? || @description.blank?) && (resource = Resource.find_by url: url)
          @title = resource.title if @title.blank?
          @description = resource.teaser if @description.blank?
        end

        @subject = @opts[:metadata].resource_subject
        embeded_object_for url, @subject
      end
    end
  end

  Template.register_tag(Tags::PdTag::TAG_NAME, Tags::PdTag)
end
