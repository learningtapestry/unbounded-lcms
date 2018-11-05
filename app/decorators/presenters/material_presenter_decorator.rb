# frozen_string_literal: true

MaterialPresenter.class_eval do
  def identifier
    metadata.identifier
  end

  def cc_attribution
    metadata.cc_attribution.presence || lesson&.cc_attribution
  end

  def content_type
    metadata.type
  end

  def name_date?
    # toggle display of name-date row on the header
    # https://github.com/learningtapestry/unbounded/issues/422
    # Added the config definition for new types. If config says "NO", it's impossible to force-add the name-date field.
    # It's impossible only to remove it when config allows it
    !metadata.name_date.to_s.casecmp('no').zero? && config[:name_date]
  end

  def orientation
    metadata.orientation.presence || super
  end

  def preserve_table_padding?
    metadata.preserve_table_padding.casecmp('yes').zero?
  end

  def show_title?
    metadata.show_title.casecmp('yes').zero?
  end

  def title
    metadata.title.presence || config[:title].presence || DEFAULT_TITLE
  end

  def unit_level?
    metadata.breadcrumb_level == 'unit'
  end

  def vertical_text?
    metadata.vertical_text.present?
  end
end
