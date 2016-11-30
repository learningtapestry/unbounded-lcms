class ResourcePresenter < SimpleDelegator
  def color_code(g = 'base')
    subject_color_code = try(:subject) || 'default'
    "#{subject_color_code}-#{g}"
  end

  def page_title(g = 'base')
    grade_color_code = g.include?('k') ? g : "G#{g}"
    "#{subject.try(:upcase)} #{grade_color_code.try(:upcase)}: #{title}"
  end

  def downloads_indent
    pdf_downloads? ? 'u-li-indent' : ''
  end
end
