class CurriculumPresenter < SimpleDelegator
  def subject_and_grade_title
    subject = resource.subject.try(:titleize)
    grade = current_grade.resource.grades.first.try(:name).try(:titleize)
    "#{subject} #{grade}"
  end

  def type_name
    curriculum_type.name.capitalize
  end
end
