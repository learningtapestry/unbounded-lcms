# frozen_string_literal: true

class ContentPresenter < BasePresenter
  CONFIG_PATH = Rails.root.join('config', 'pdf.yml')
  DEFAULT_CONFIG = :default
  MATERIALS_CONFIG_PATH = Rails.root.join('config', 'materials_rules.yml')
  PART_RE = /{{[^}]+}}/

  def self.base_config
    @base_config ||= YAML.load_file(CONFIG_PATH).deep_symbolize_keys
  end

  def self.materials_config
    @materials_config ||= YAML.load_file(MATERIALS_CONFIG_PATH).deep_symbolize_keys
  end

  def base_filename
    name = short_breadcrumb(join_with: '_', with_short_lesson: true)
    "#{name}_v#{version.presence || 1}"
  end

  def config
    @config ||= self.class.base_config[DEFAULT_CONFIG].deep_merge(self.class.base_config[content_type.to_sym] || {})
  end

  def content_type
    @content_type.presence || 'none'
  end

  def footer_margin_styles
    padding_styles(align_type: 'margin')
  end

  def gdoc_folder
    "#{id}_v#{version}"
  end

  def gdoc_key
    DocumentExporter::Gdoc::Base.gdoc_key(content_type)
  end

  def initialize(obj, opts = {})
    super(obj)
    opts.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def materials_config_for(type)
    self.class.materials_config[type.to_sym].flat_map do |k, v|
      v.map { |x| { k => x } }
    end
  end

  def orientation
    config[:orientation]
  end

  def padding_styles(align_type: 'padding')
    config[:padding].map { |k, v| "#{align_type}-#{k}:#{v};" }.join
  end

  def render_content(context_type, options = {})
    content = HtmlSanitizer.clean_content(
      render_part(layout_content(context_type), options),
      context_type
    )
    ReactMaterialsResolver.resolve(content, self)
  end

  def render_part(part_content, options) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    excludes = options[:excludes] || []
    part_content.gsub(PART_RE) do |placeholder|
      next unless placeholder
      next unless (part = document_parts_index[placeholder])

      # If part is optional:
      # - do not render it if optional have not been requested (not web-view)
      # - do not render it if optional part was not turned ON (is not inside excludes list)
      # If part is not optional:
      # - just ignore it if it has been turned OFF

      if part[:optional] && !options[:with_optional]
        next unless excludes.include?(part[:anchor])
      elsif excludes.include?(part[:anchor])
        next
      end

      next unless (subpart = part[:content])
      render_part subpart.to_s, options
    end
  end
end
