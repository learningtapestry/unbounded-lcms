class ResourcePresenter < SimpleDelegator
  def color_code(grade_color_code = 'base')
    subject_color_code = try(:subject) || 'default'
    "#{subject_color_code}-#{grade_color_code}"
  end
end
