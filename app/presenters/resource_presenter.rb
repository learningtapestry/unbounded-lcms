class ResourcePresenter < SimpleDelegator
  def tags
    super.sort.join(', ')
  end

  def color_code(grade_color_code = 'base')
    subject_color_code = try(:subject) || 'default'
    "#{subject_color_code}-#{grade_color_code}"
  end

  protected
    def h
      ApplicationController.helpers
    end
end
