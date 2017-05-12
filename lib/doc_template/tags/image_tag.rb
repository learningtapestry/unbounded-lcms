module DocTemplate
  module Tags
    class ImageTag < BaseTag
      include ERB::Util

      TAG_NAME = 'image'.freeze
      TEMPLATE = 'image.html.erb'.freeze

      def parse(node, opts = {})
        return self unless (table = node.ancestors('table').first)

        @image_src = image_src opts
        @caption = table.at_xpath('.//tr[2]/td').text
      @subject = opts[:metadata].try(:[], 'subject')

        # we should replace the whole table with new content
        template = File.read template_path(TEMPLATE)
        table.replace ERB.new(template).result(binding)
        @result = table
        self
      end

      private

      def image_src(opts = {})
        filename = "#{opts[:value]}.jpg"
        grade = opts[:metadata]['grade']
        unit = opts[:metadata]['unit']
        "https://unbounded-uploads-development.s3.amazonaws.com/ela-images/G#{grade}/#{unit}/#{filename}"
      end
    end
  end

  Template.register_tag(Tags::ImageTag::TAG_NAME, Tags::ImageTag)
end
