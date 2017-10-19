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

    attr_reader :activity_metadata, :css_styles, :section_metadata, :toc

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

    def foundational?
      metadata['type'].to_s.casecmp('fs').zero?
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

    def meta_options(context_type)
      @meta_options ||=
        if material?
          {
            metadata: Objects::MaterialMetadata.build_from(@metadata.data),
            material: true
          }
        else
          {
            foundational_metadata: Objects::BaseMetadata.build_from(@foundational_metadata.data),
            metadata: Objects::BaseMetadata.build_from(@metadata.data),
            parts: @target_table.try(:parts)
          }
        end
      @meta_options.merge(context_type: context_type)
    end

    def parse(source)
      doc = Nokogiri::HTML(source)
      # get css styles from head to keep classes for lists (preserve list-style-type)
      doc = HtmlSanitizer.process_list_styles doc
      @css_styles = HtmlSanitizer.sanitize_css(doc.xpath('//html/head/style/text()').to_s)

      # clean all the inline styles
      body_node = HtmlSanitizer.sanitize(doc.xpath('//html/body/*').to_s)
      @content = Nokogiri::HTML.fragment(body_node)

      parse_metadata

      CONTEXT_TYPES.each do |context_type|
        options = meta_options(context_type)
        unless material?
          # Rebuild meta options from scratch for each context
          options[:activity] = Objects::ActivityMetadata.build_from(@activity_metadata)
          options[:agenda] = Objects::AgendaMetadata.build_from(@agenda.data)
          options[:sections] = Objects::SectionsMetadata.build_from(@section_metadata, template_type)
        end
        @documents[context_type] = DocTemplate::Document.parse(@content.dup, options)
        @documents[context_type].parts << {
          content: render(options),
          context_type: context_type,
          materials: [],
          optional: false,
          part_type: :layout,
          placeholder: nil
        }

        @toc ||= DocumentTOC.parse(options) unless material?
      end

      self
    end

    def parts
      @documents.values.flat_map(&:parts)
    end

    def remove_part(type, context_type)
      result = nil
      @documents.keys.each do |k|
        result = @documents[k].parts.detect { |p| p[:part_type] == type && p[:context_type] == context_type }
        @documents[k].parts.delete(result) && break if result.present?
      end
      result
    end

    def render(options = {})
      type = options.fetch(:context_type, CONTEXT_TYPES.first)
      HtmlSanitizer.post_processing(@documents[type]&.render.presence || '', options)
    end

    private

    attr_accessor :content

    def parse_metadata
      if material?
        @metadata = Tables::MaterialMetadata.parse content
        raise MaterialError, 'No metadata present' if @metadata.data.empty?
      else
        @metadata = Tables::Metadata.parse content
        @agenda = Tables::Agenda.parse content
        @section_metadata = Tables::Section.parse content
        @activity_metadata = Tables::Activity.parse content, template_type
        @target_table = Tables::Target.parse(content) if target_table?

        @foundational_metadata = if foundational?
                                   @metadata
                                 else
                                   Tables::FoundationalMetadata.parse content
                                 end
      end
    end

    def target_table?
      @metadata && @metadata.data['subject'].try(:downcase) == 'ela' && @metadata.data['grade'] == '6'
    end

    def template_type
      foundational? ? 'fs' : 'core'
    end
  end
end
