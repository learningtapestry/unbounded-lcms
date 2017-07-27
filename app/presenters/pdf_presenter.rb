# frozen_string_literal: true

class PDFPresenter < BasePresenter
  CONFIG_PATH = Rails.root.join('config', 'pdf.yml')
  DEFAULT_CONFIG = :default

  def self.base_config
    @base_config ||= YAML.load_file(CONFIG_PATH).deep_symbolize_keys
  end

  def initialize(obj, opts = {})
    super(obj)
    opts.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def config
    @config ||= self.class.base_config[DEFAULT_CONFIG].deep_merge(self.class.base_config[pdf_type.to_sym] || {})
  end

  def footer_margin_styles
    padding_styles(align_type: 'margin')
  end

  def padding_styles(align_type: 'padding')
    config[:padding].map { |k, v| "#{align_type}-#{k}:#{v};" }.join
  end

  def pdf_type
    @pdf_type.presence || 'none'
  end
end
