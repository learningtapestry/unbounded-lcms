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

    attr_reader :activity_metadata, :toc, :css_styles

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

    def foundational_metadata
      @foundational_metadata.data.presence || {}
    end

    def metadata
      @metadata.data.presence || {}
    end

    def parse(source)
      doc = Nokogiri::HTML(source)
      # get css styles from head to keep classes for lists (preserve list-style-type)
      @css_styles = HtmlSanitizer.sanitize_css(doc.xpath('//html/head/style/text()').to_s)

      # clean all the inline styles
      body_node = HtmlSanitizer.sanitize(doc.xpath('//html/body/*').to_s)
      body_fragment = Nokogiri::HTML.fragment(body_node)

      # parse tables
      parse_tables body_fragment

      @root = Document.parse(body_fragment, meta_options)
      @toc = DocumentTOC.parse(meta_options)
      self
    end

    def meta_options
      @meta_options ||= {
        activity: Objects::ActivityMetadata.build_from(@activity_metadata),
        agenda:   Objects::AgendaMetadata.build_from(@agenda.data),
        foundational_metadata: Objects::BaseMetadata.build_from(@foundational_metadata.data),
        metadata: Objects::BaseMetadata.build_from(@metadata.data)
      }
    end

    def render
      @root.render.presence || ''
    end

    private

    def parse_tables(html)
      @metadata = Tables::Metadata.parse html
      @agenda = Tables::Agenda.parse html
      @activity_metadata = Tables::Activity.parse html
      @foundational_metadata = Tables::FoundationalMetadata.parse html
      Tables::Target.parse(html) if @metadata.data['subject'].try(:downcase) == 'ela' && @metadata.data['grade'] == '6'
    end
  end
end
