module ApplicationHelper
  def nav_link(link_text, link_path, attrs = {})
    class_name = current_page?(link_path) ? 'active' : nil
    content_tag(:li, attrs.merge(class: class_name)) { link_to link_text, link_path }
  end

  def page_title
    if content_for?(:page_title)
      content_for(:page_title)
    else
      controller = controller_path.gsub('/', '.')
      t("#{controller}.#{action_name}.page_title")
    end
  rescue I18n::MissingTranslationData
    t('unbounded.browser')
  end

  def set_page_title(title)
    content_for :page_title do
      title
    end
  end
end
