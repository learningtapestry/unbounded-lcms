module DocTemplate
  class Template
    # a registry for available tags and respective classes
    class TagRegistry
      include Enumerable

      def initialize
        @tags = {}
      end

      # returns the default tag if the tag is unknown
      def [](tag_name)
        tag_to_load = @tags.key?(tag_name) ? tag_name : 'default'
        @tags[tag_to_load]
      end

      def []=(tag_name, klass)
        @tags[tag_name] = klass
      end

      private

      def load_class(klass_name)
        Object.const_get(klass_name)
      end
    end

    def self.parse(source)
      new.parse(source)
    end

    def parse(source)
      doc = Nokogiri::HTML(source)
      # clean all the inline styles
      doc.xpath('@style|.//@style').remove
      body_node = doc.xpath('//html/body/*').to_s
      body_fragment = Nokogiri::HTML.fragment(body_node)
      @metadata = MetaTable.parse(body_fragment)
      @root = Document.parse(body_fragment, metadata: metadata)
      self
    end

    def self.register_tag(name, klass)
      self.tags[name.to_s] = klass
    end

    def self.tags
      @tags ||= TagRegistry.new
    end

    def render
      return '' if @root.nil?
      @root.render
    end

    def metadata
      @metadata.data.presence || {}
    end
  end
end
