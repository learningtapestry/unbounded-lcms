module ApplicationHelper
  def nav_link(link_text, link_path, attrs = {})
    class_name = current_page?(link_path) ? 'active' : nil
    content_tag(:li, attrs.merge(class: class_name)) { link_to link_text, link_path }
  end
end
