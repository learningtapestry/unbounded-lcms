class LessonPresenter < SimpleDelegator
  def units
    curriculums.map { |c| c.ancestors.where(curriculum_type: CurriculumType.unit).first.resource }
  end

  def unit
    units.first
  end
end
