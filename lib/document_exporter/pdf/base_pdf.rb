# frozen_string_literal: true

module DocumentExporter
  module PDF
    class BasePDF
      CONFIG_PATH = Rails.root.join('config', 'materials_rules.yml')

      def self.config
        @config ||= YAML.load_file(CONFIG_PATH).deep_symbolize_keys
      end

      def config_for(type)
        self.class.config[type.to_sym].flat_map do |k, v|
          v.map { |x| { k => x } }
        end
      end

      def self.pdf_key(type)
        type == 'full' ? 'pdf' : "pdf_#{type}"
      end

      def initialize(document, options = {})
        @document = document
        @options = options
      end

      def export
        content = render_template 'show', layout: 'cg_pdf'
        WickedPdf.new.pdf_from_string(content, pdf_params)
      end

      #
      # Take into consideration that in one component materilas are uniq. So
      # just the first occurence of exluded material is removed
      #
      def included_materials
        return [] unless @options[:excludes].present?

        @included_materials ||= [].tap do |result|
          result.concat @document.document_parts.pluck(:materials).flatten.compact

          excluded = @options[:excludes].map do |x|
            @document.document_parts.find_by(placeholder: "{{#{x}}}")&.materials
          end.flatten.compact

          excluded.each do |id|
            result.delete_at result.index(id)
          end
        end
      end

      private

      def pdf_custom_params
        @document.config.slice(:margin, :orientation)
      end

      def pdf_params
        {
          disable_internal_links: false,
          disable_external_links: false,
          disposition: 'attachment',
          footer: {
            content: render_template('_footer'),
            line: false,
            spacing: 2
          },
          javascript_delay: 5000,
          outline: { outline_depth: 3 },
          page_size: 'Letter',
          print_media_type: false
        }.merge(pdf_custom_params)
      end

      def render_template(name, layout: 'cg_plain_pdf')
        # Using backport of Rails 5 Renderer here
        ApplicationController.render(
          template: template_path(name),
          layout: layout,
          locals: { document: @document, options: @options }
        )
      end

      def template_path(name)
        File.join('documents', 'pdf', name)
      end
    end
  end
end
