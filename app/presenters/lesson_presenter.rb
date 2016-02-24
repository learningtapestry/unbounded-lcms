class LessonPresenter < SimpleDelegator
  def units
    curriculums.map { |c| c.ancestors.where(curriculum_type: CurriculumType.unit).first.resource }
  end

  def unit
    @unit ||= units.first
  end

  def subject
    @subject ||= unit.subjects.first
  end

  def grade
    @grade ||= unit.grades.first
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

  def curriculum
    @curriculum ||= curriculums.first
  end

  def next
    @next ||= curriculum.next.try(:resource)
  end

  def previous
    @previous ||= curriculum.previous.try(:resource)
  end
end
