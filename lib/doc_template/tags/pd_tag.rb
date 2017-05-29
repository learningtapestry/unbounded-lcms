module DocTemplate
  module Tags
    class PdTag < BaseTag
      include ERB::Util
      include SoundcloudEmbed
      include VideoEmbed

      TAG_NAME = 'pd'.freeze
      TEMPLATE = 'pd.html.erb'.freeze
      TYPE_PODCAST = 'podcast'.freeze
      TYPE_YOUTUBE = 'youtube'.freeze

      def parse(node, opts = {})
        @opts = opts
        url, @title, @description = @opts[:value].split(';').map(&:strip)

        fetch_data_for url

        unless @embeded.present?
          node.remove
          @result = node
          return self
        end

        template = File.read template_path(TEMPLATE)
        node.replace ERB.new(template).result(binding)
        @result = node
        self
      end

      private

      def embeded_object_for(url, subject)
        if url.index('soundcloud.com')
          {
            content: soundcloud_embed(url, subject),
            type: TYPE_PODCAST
          }
        elsif url.index('youtube.com')
          {
            content: "https://www.youtube.com/embed/#{video_id(url)}",
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
        @embeded = embeded_object_for url, @subject
      end
    end
  end

  Template.register_tag(Tags::PdTag::TAG_NAME, Tags::PdTag)
end
