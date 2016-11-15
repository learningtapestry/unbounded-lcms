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
    resource_downloads.group_by { |d| d.download_category.try(:category_name) || '' }
                      .sort_by { |k, _| k }.to_h
                      .transform_values { |v| v.map(&:download).sort_by(&:attachment_url) }
  end
end
