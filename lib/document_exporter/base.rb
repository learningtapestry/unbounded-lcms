# frozen_string_literal: true

module DocumentExporter
  class Base
    def self.pdf_key(type)
      type == 'full' ? 'pdf' : "pdf_#{type}"
    end

    def initialize(document, options = {})
      @document = document
      @options = options
    end

    def export
      raise NotImplementedError
    end

    #
    # Take into consideration that in one component materilas are uniq. So
    # just the first occurence of exluded material is removed
    #
    def included_materials(context_type: :default)
      return [] unless @options[:excludes].present?
      parts = context_type == :default ? @document.document_parts.default : @document.document_parts.gdoc

      @included_materials ||= [].tap do |result|
        result.concat parts.pluck(:materials).flatten.compact

        excluded = @options[:excludes].map do |x|
          parts.find_by(anchor: x)&.materials
        end.flatten.compact

        excluded.each do |id|
          result.delete_at result.index(id)
        end
        result
      end.map(&:to_i)
    end

    def ordered_materials(material_ids)
      @document.ordered_material_ids & material_ids
    end

    private

    def base_path(name)
      File.join('documents', 'pdf', name)
    end

    def render_template(name, layout:)
      # Using backport of Rails 5 Renderer here
      ApplicationController.render(
        template: name,
        layout: layout,
        locals: { document: @document, options: @options }
      )
    end

    def template_path(name)
      base_path(name)
    end
  end
end
