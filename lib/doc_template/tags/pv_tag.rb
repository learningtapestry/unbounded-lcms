module DocTemplate
  module Tags
    class PvTag < BaseTag
      TAG_NAME = 'pv'.freeze
      TEMPLATE = 'pv.html.erb'.freeze

      def parse(node, opts = {})
        config = self.class.config[TAG_NAME.downcase]
        if config && (@data = config[opts[:value].to_s.downcase]).present?
          template = File.read template_path(TEMPLATE)
          node = node.replace ERB.new(template).result(binding)
        end

        @result = node
        self
      end
    end

    Template.register_tag(Tags::PvTag::TAG_NAME, PvTag)
  end
end
