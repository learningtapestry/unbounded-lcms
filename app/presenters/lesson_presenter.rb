class LessonPresenter < SimpleDelegator
  def units
    curriculums.map { |c| c.ancestors.where(curriculum_type: CurriculumType.unit).first.resource }
  end

  def unit
    units.first
  end

  def subject
    unit.subjects.first
  end

  def grade
    unit.grades.first
  end

  def subject_and_grade_title
    "#{subject.name.titleize} / #{grade.name}"
  end

  def teaser_text
    description.truncate_words(25).html_safe
  end

  def tags
    subjects.map(&:name).join(', ')
  end
end
