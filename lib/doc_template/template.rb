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

    attr_reader :activity_metadata
    attr_reader :toc

    def self.parse(source)
      new.parse(source)
    end

    def self.register_tag(name, klass)
      self.tags[name.to_s] = klass
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
      opts = meta_options
      @root = Document.parse(body_fragment, opts)
      @toc = DocumentTOC.parse(opts)
      self
    end

    def meta_options
      opts_metadata = BaseMetadata.new(@metadata.data)
      opts_agenda   = AgendaMetadata.build_from(@agenda.data)
      opts_activity = ActivityMetadata.build_from(@activity_metadata)
      { metadata: opts_metadata,
        agenda:   opts_agenda,
        activity: opts_activity }
    end

    def render
      @root.render.presence || ''
    end
  end
end
