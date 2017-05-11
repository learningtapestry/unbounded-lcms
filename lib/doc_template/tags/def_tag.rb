module DocTemplate
  class DefTag < Tag
    include ERB::Util

    TAG_NAME = 'def'.freeze
    TAG_SEPARATOR = '[separator]'.freeze
    TEMPLATE = 'def.html.erb'.freeze

    def parse(node, opts = {})
      # preserving text around tag
      @data = {}
      if (data = node.content.sub(/\[[^\]]*\]/, TAG_SEPARATOR).split(TAG_SEPARATOR, 2))
        @data[:append] = data[1]
        @data[:prepend] = data[0]
      end

      @definition, @description = opts[:value].split(';').map(&:strip)

      template = File.read template_path(TEMPLATE)
      node.replace ERB.new(template).result(binding)
      @result = node
      self
    end
  end

  Template.register_tag(DefTag::TAG_NAME, DefTag)
end
