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

      def keys
        @tags.keys
      end

      private

      def load_class(klass_name)
        Object.const_get(klass_name)
      end
    end

    attr_reader :activity_metadata
    attr_reader :toc

    def self.parse(source)
      new.parse(source)
    end

    def self.register_tag(name, klass)
      key = name.is_a?(Regexp) ? name : name.to_s
      tags[key] = klass
    end

    def self.tags
      @tags ||= TagRegistry.new
    end

    def agenda
      @agenda.data.presence || []
    end

    def metadata
      @metadata.data.presence || {}
    end

    def parse(source)
      doc = Nokogiri::HTML(source)
      # clean all the inline styles
      body_node = HtmlSanitizer.sanitize(doc.xpath('//html/body/*').to_s)
      body_fragment = Nokogiri::HTML.fragment(body_node)
      @metadata = MetaTable.parse(body_fragment)
      @agenda = AgendaTable.parse(body_fragment)
      @activity_metadata = ActivityTable.parse(body_fragment)
      FoundationalMetaTable.parse(body_fragment)
      @root = Document.parse(body_fragment, meta_options)
      @toc = DocumentTOC.parse(meta_options)
      self
    end

    def meta_options
      @meta_options ||= {
        metadata: Objects::BaseMetadata.new(@metadata.data),
        agenda:   Objects::AgendaMetadata.build_from(@agenda.data),
        activity: Objects::ActivityMetadata.build_from(@activity_metadata)
      }
    end

    def render
      @root.render.presence || ''
    end
  end
end
