class ResourcePresenter < SimpleDelegator
  def color_code(g = 'base')
    subject_color_code = try(:subject) || 'default'
    "#{subject_color_code}-#{g}"
  end

  def page_title(g = 'base')
    grade_color_code = g.include?('k') ? g : "G#{g}"
    "#{subject.try(:upcase)} #{grade_color_code.try(:upcase)}: #{title}"
  end

  def download_categories
    default_title = h.t('resources.title.download_category')
    download_groups = resource_downloads.group_by { |d| d.try(:download_category).try(:category_name) || default_title }
                                        .sort_by { |k, _| k }.to_h
                                        .transform_values { |v| v.sort_by { |d| d.download.attachment_url } }
    return download_groups unless download_groups.key?(default_title)
    { default_title => download_groups.delete(default_title) }.merge(download_groups)
  end

  private

  def h
    ApplicationController.helpers
  end
end
