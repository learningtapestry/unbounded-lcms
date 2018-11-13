# frozen_string_literal: true

module DocTemplate
  module Tags
    BaseTag.class_eval do
      CONFIG_PATH = Rails.root.join('config', 'tags.yml')

      def self.config
        @config ||= YAML.load_file(CONFIG_PATH)
      end

      def tags(key)
        self.class.config[self.class::TAG_NAME.downcase][key].map do |stop_tag|
          Tags.const_get(stop_tag)::TAG_NAME
        end.join('|')
      end

      def template_name(opts)
        self.class::TEMPLATES[opts.fetch(:context_type, :default).to_sym]
      end

      def template_path(name)
        self.class.template_path_for name
      end
    end
  end
end