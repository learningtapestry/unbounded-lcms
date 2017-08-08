# frozen_string_literal: true

module DocTemplate
  CONTEXT_TYPES = %w(default gdoc).freeze

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

    def self.parse(source, type: :document)
      new(type).parse(source)
    end

    def self.register_tag(name, klass)
      key = name.is_a?(Regexp) ? name : name.to_s
      tags[key] = klass
    end

    def self.tags
      @tags ||= TagRegistry.new
    end

    def initialize(type = :document)
      @type = type
      @documents = {}
    end

    def agenda
      @agenda.data.presence || []
    end

    def foundational_metadata
      @foundational_metadata.data.presence || {}
    end

    def material?
      @type.to_sym == :material
    end

    def metadata
      @metadata.data.presence || {}
    end

    def parse(source)
      doc = Nokogiri::HTML(source)
      # get css styles from head to keep classes for lists (preserve list-style-type)
      doc = HtmlSanitizer.process_list_styles doc
      @css_styles = HtmlSanitizer.sanitize_css(doc.xpath('//html/head/style/text()').to_s)

      # clean all the inline styles
      body_node = HtmlSanitizer.sanitize(doc.xpath('//html/body/*').to_s)
      body_fragment = Nokogiri::HTML.fragment(body_node)

      # parse tables
      parse_tables body_fragment

      default_opts = meta_options(CONTEXT_TYPES[0])

      CONTEXT_TYPES.each_with_index do |context_type, idx|
        options = idx.zero? ? default_opts : meta_options(context_type)
        @documents[context_type] = DocTemplate::Document.parse(body_fragment.dup, options)
        @documents[context_type].parts << {
          content: render(options),
          context_type: context_type,
          materials: [],
          part_type: :layout,
          placeholder: nil
        }
      end

      @toc = DocumentTOC.parse(default_opts) unless material?
      self
    end

    def meta_options(context_type)
      if material?
        {
          context_type: context_type,
          metadata: Objects::MaterialMetadata.build_from(@metadata.data),
          material: true
        }
      else
        {
          activity: Objects::ActivityMetadata.build_from(@activity_metadata),
          agenda: Objects::AgendaMetadata.build_from(@agenda.data),
          context_type: context_type,
          foundational_metadata: Objects::BaseMetadata.build_from(@foundational_metadata.data),
          metadata: Objects::BaseMetadata.build_from(@metadata.data),
          parts: @target_table.try(:parts)
        }
      end
    end

    def parts
      @documents.values.flat_map(&:parts)
    end

    def render(options = {})
      type = options.fetch(:context_type, CONTEXT_TYPES.first)
      HtmlSanitizer.post_processing(@documents[type]&.render.presence || '', options)
    end

    private

    def parse_tables(html)
      if material?
        @metadata = Tables::MaterialMetadata.parse html
      else
        @metadata = Tables::Metadata.parse html
        @agenda = Tables::Agenda.parse html
        @activity_metadata = Tables::Activity.parse html
        @foundational_metadata = Tables::FoundationalMetadata.parse html
        @target_table = Tables::Target.parse(html) if target_table?
      end
    end

    def target_table?
      @metadata && @metadata.data['subject'].try(:downcase) == 'ela' && @metadata.data['grade'] == '6'
    end
  end
end
