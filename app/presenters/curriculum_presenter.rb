class CurriculumPresenter < SimpleDelegator
  def active?(node)
    @active ||= (ancestor_ids << id)
    @active.include?(node.id)
  end

  def module_width(node)
    # Store the lesson count for each module
    @lesson_counts ||= begin
      lesson_counts = {}
      current_grade.modules.each do |mod|
        count = mod.lessons.count
        count = 1 if count == 0
        lesson_counts[mod.id] = count
      end
      lesson_counts
    end

    # Max lesson count
    @max_lesson_count ||= @lesson_counts.values.max.to_f

    # Translate and scale the values above.
    # Min width: 70%, max width: 100%
    30 * (@lesson_counts[node.id]/@max_lesson_count) + 70
  end

  def subject_and_grade_title
    subject = resource.subject.try(:upcase)
    grade = current_grade.resource.grades.first.try(:name).try(:titleize)
    "#{subject} #{grade}"
  end

  def type_name
    curriculum_type.name.capitalize
  end
end
