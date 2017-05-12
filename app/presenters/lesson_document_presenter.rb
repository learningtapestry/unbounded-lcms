class LessonDocumentPresenter < BasePresenter
  TOPIC_FULL   = { 'ela' => 'Unit', 'math' => 'Topic' }.freeze
  TOPIC_SHORT  = { 'ela' => 'U', 'math' => 'T' }.freeze
  SUBJECT_FULL = { 'ela' => 'ELA', 'math' => 'Math' }.freeze

  def ld_metadata
    @ld_metadata ||= DocTemplate::Objects::BaseMetadata.build_from(metadata)
  end

  def color_code
    "#{subject}-base"
  end

  def color_code_grade
    "#{subject}-#{grade}"
  end

  def full_breadcrumb
    [
      SUBJECT_FULL[subject] || subject,
      grade.to_i.zero? ? grade : "Grade #{grade}",
      ll_strand? ? ld_module : "Module #{ld_module.try(:upcase)}",
      "#{TOPIC_FULL[subject]} #{topic.try(:upcase)}",
      "Lesson #{ld_metadata.lesson}"
    ].join(' / ')
  end

  def short_breadcrumb
    [
      SUBJECT_FULL[subject] || subject,
      grade.to_i.zero? ? grade : "G#{grade}",
      ll_strand? ? 'LL' : "M#{ld_module.try(:upcase)}",
      "#{TOPIC_SHORT[subject]}#{topic.try(:upcase)}",
      "Lesson #{ld_metadata.lesson}"
    ].join(' / ')
  end

  def short_title
    "Lesson #{ld_metadata.lesson}"
  end

  def standards
    ld_metadata.standard || ld_metadata.lesson_standard
  end

  def math_practice
    ld_metadata.lesson_mathematical_practice.squish
  end

  def title
    ld_metadata.title
  end

  def teaser
    ld_metadata.teaser
  end

  def description
    ld_metadata.lesson_objective || ld_metadata.description
  end

  def subject
    ld_metadata.resource_subject
  end

  def grade
    ld_metadata.grade[/\d+/] || ld_metadata.grade
  end

  def ld_module
    ela? ? ld_metadata.module : ld_metadata.unit
  end

  def topic
    ela? ? ld_metadata.unit : ld_metadata.topic
  end

  def ll_strand?
    ld_metadata.module =~ /strand/i
  end
end
