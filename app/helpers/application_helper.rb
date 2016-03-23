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

  def nav_link(link_text, link_path, attrs = {})
    cls = active_class(link_path, attrs[:class])
    content_tag(:li, attrs.merge(class: cls)) { link_to link_text, link_path }
  end

  def page_title
    if content_for?(:page_title)
      content_for(:page_title)
    else
      controller = controller_path.gsub('/', '.')
      t("#{controller}.#{action_name}.page_title", default: t('default_title'))
    end
  end

  def set_page_title(title)
    content_for :page_title do
      title
    end
  end
end
