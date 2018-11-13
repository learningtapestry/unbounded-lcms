# frozen_string_literal: true

module DocTemplate
  class Template
    include Concerns::DocTemplate::Template

    CONTEXT_TYPES = %w(default gdoc).freeze

    attr_reader :activity_metadata, :css_styles, :section_metadata, :toc

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
          data: {},
          materials: [],
          optional: false,
          part_type: :layout,
          placeholder: nil
        }

        @toc ||= DocumentTOC.parse(options) unless material?
      end

      self
    end

    def render(options = {})
      type = options.fetch(:context_type, CONTEXT_TYPES.first)
      HtmlSanitizer.post_processing(@documents[type]&.render.presence || '', options)
    end

    private

    def parse_metadata
      if material?
        @metadata = Tables::MaterialMetadata.parse content
        raise MaterialError, 'No metadata present' if @metadata.data.empty?
      else
        @metadata = Tables::Metadata.parse content
        @agenda = Tables::Agenda.parse content
        @section_metadata = Tables::Section.parse content, 'core', force_inject_section?
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
      return false unless @metadata.present?

      @metadata.data['subject']&.downcase == 'ela' && @metadata.data['grade'] == '6'
    end

    def template_type
      foundational? ? 'fs' : 'core'
    end
  end
end
