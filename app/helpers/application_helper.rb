# frozen_string_literal: true

module ApplicationHelper # rubocop:disable Metrics/ModuleLength
  ENABLE_BASE64_CACHING = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(
    ENV.fetch('ENABLE_BASE64_CACHING', true)
  )

  def add_class_for_path(link_path, klass, klass_prefix = nil)
    [
      klass_prefix,
      current_page?(link_path) ? klass : nil
    ].compact.join(' ')
  end

  def add_class_for_action(controller_name, action_name, klass, klass_prefix = nil)
    sufix = klass if controller.controller_name == controller_name.to_s && controller.action_name == action_name.to_s
    "#{klass_prefix} #{sufix}"
  end

  def nav_link(link_text, link_path, attrs = {}, link_attrs = {})
    cls = add_class_for_path(link_path, 'active', attrs[:class])
    content_tag(:li, attrs.merge(class: cls)) { link_to link_text, link_path, link_attrs }
  end

  def header_mod
    controller.controller_name
  end

  def page_title
    if content_for?(:page_title)
      page_title = content_for(:page_title)
    else
      controller = controller_path.tr('/', '.')
      page_title = t("#{controller}.#{action_name}.page_title", default: t('default_title'))
    end
    strip_tags_and_squish(page_title)
  end

  def page_description
    if content_for?(:description)
      page_description = content_for(:description)
    else
      controller = controller_path.tr('/', '.')
      page_description = t("#{controller}.#{action_name}.page_description", default: t('default_description'))
    end
    strip_tags_and_squish(page_description)
  end

  def page_og_image
    if content_for?(:og_image)
      page_og_image = content_for(:og_image)
    else
      controller = controller_path.tr('/', '.')
      page_og_image = t("#{controller}.#{action_name}.og_image", default: t('default_og_image'))
    end
    page_og_image
  end

  # Render meta tag
  def redirect_meta_tag
    content_for(:redirect_meta_tag) if content_for?(:redirect_meta_tag)
  end

  # Use in views as redirection directive
  def redirect_via_meta_tag(to_url:, delay: 5)
    content_for(:redirect_meta_tag) do
      content_tag(:meta, nil, { content: "#{delay};url=#{to_url}", 'http-equiv' => 'refresh' }, true)
    end
  end

  def redis
    Rails.application.config.redis
  end

  def set_page_title(title) # rubocop:disable Style/AccessorMethodName
    content_for :page_title do
      title
    end
  end

  def set_page_description(dsc) # rubocop:disable Style/AccessorMethodName
    content_for :description do
      dsc
    end
  end

  def set_canonical_url(value) # rubocop:disable Style/AccessorMethodName
    content_for(:canonical_url, value)
  end

  def base64_encoded_asset(path) # rubocop:disable Metrics/PerceivedComplexity
    key = "ub-b64-asset:#{path}"

    if ENABLE_BASE64_CACHING
      b64_asset = redis.get(key)
      return b64_asset if b64_asset.present?
    end

    if Rails.env.development? || Rails.env.test?
      asset = Rails.application.assets.find_asset(path)
      content_type = asset.content_type
    else
      filesystem_path = Rails.application.assets_manifest.assets[path]
      asset = File.read(Rails.root.join('public', 'assets', filesystem_path))
      content_type = Mime::Type.lookup_by_extension(File.extname(path).split('.').last)
    end
    raise "Could not find asset '#{path}'" if asset.nil?

    encoded = Base64.encode64(asset.to_s).gsub(/\s+/, '')
    b64_asset = "data:#{content_type};base64,#{Rack::Utils.escape(encoded)}"

    redis.set key, b64_asset, ex: 1.day.to_i if ENABLE_BASE64_CACHING

    b64_asset
  end

  def inlined_asset(path)
    if Rails.env.development? || Rails.env.test?
      asset = Rails.application.assets.find_asset(path)
    else
      filesystem_path = Rails.application.assets_manifest.assets[path]
      asset = File.read(Rails.root.join('public', 'assets', filesystem_path))
    end
    asset
  end

  def strip_tags_and_squish(str)
    return unless str.respond_to? :squish
    strip_tags(str).squish
  end

  def generic_page?
    controller.controller_name == 'resources' && controller.action_name == 'generic'
  end

  def cg_page?
    controller.controller_name == 'content_guides' && controller.action_name == 'show'
  end

  def set_social_media_sharing(target) # rubocop:disable Style/AccessorMethodName
    @social_media_presenter = SocialMediaPresenter.new(target: target, view: self)
  end

  def social_media
    @social_media_presenter || SocialMediaPresenter.new(target: nil, view: self)
  end

  def color_code(model, base: false)
    subject_color_code = model.try(:subject) || 'default'
    grade_avg = base ? 'base' : model.grades.average
    "#{subject_color_code}-#{grade_avg}"
  end

  def selected_id?(id)
    selected_ids = params[:selected_ids]
    return unless selected_ids.present?

    case selected_ids
    when Array then selected_ids.include?(id.to_s)
    else selected_ids.split(',').include?(id.to_s)
    end
  end
end
