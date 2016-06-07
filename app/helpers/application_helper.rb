module ApplicationHelper
  def display_style(condition)
    if condition
      "style='display: block'"
    else
      "style='display: none'"
    end.html_safe
  end

  def active_class(link_path, cls = '')
    class_prefix = current_page?(link_path) ? 'active' : ''
    "#{class_prefix} #{cls}"
  end

  def active_class_resource(controller_name, action_name, cls = '')
    class_prefix = (controller.controller_name == controller_name.to_s && controller.action_name == action_name.to_s) ? 'active' : ''
    "#{class_prefix} #{cls}"
  end

  def nav_link(link_text, link_path, attrs = {})
    cls = active_class(link_path, attrs[:class])
    content_tag(:li, attrs.merge(class: cls)) { link_to link_text, link_path }
  end

  def page_title
    if content_for?(:page_title)
      page_title = content_for(:page_title)
    else
      controller = controller_path.gsub('/', '.')
      page_title = t("#{controller}.#{action_name}.page_title", default: t('default_title'))
    end
    current_page?(root_path) ? "UnboundEd" : "UnboundEd - #{page_title}"
  end

  def set_page_title(title)
    content_for :page_title do
      title
    end
  end

  def set_page_description(dsc)
    content_for :description do
      dsc
    end
  end

  def set_canonical_url(value)
    content_for(:canonical_url, value)
  end

  def page_description
    content_for(:description)
  end

  def set_og_tags(resource, image_url = nil)
    set_page_description(resource.teaser)
    content_for(:og_title, resource.title)
    content_for(:og_description, resource.teaser)
    content_for(:og_image, image_url) if image_url.present?
  end

end
