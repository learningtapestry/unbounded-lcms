class LessonDocumentPresenter < BasePresenter
  TOPIC_FULL   = { 'ela' => 'Unit', 'math' => 'Topic' }.freeze
  TOPIC_SHORT  = { 'ela' => 'U', 'math' => 'T' }.freeze
  SUBJECT_FULL = { 'ela' => 'ELA', 'math' => 'Math' }.freeze

  def color_code
    "#{subject}-base"
  end

  def color_code_grade
    "#{subject}-#{grade}"
  end

  def description
    ld_metadata.lesson_objective || ld_metadata.description
  end

  def full_breadcrumb
    [
      SUBJECT_FULL[subject] || subject,
      grade.to_i.zero? ? grade : "Grade #{grade}",
      ll_strand? ? ld_module : "Module #{ld_module.try(:upcase)}",
      topic.present? ? "#{TOPIC_FULL[subject]} #{topic.try(:upcase)}" : nil,
      resource.try(:assessment?) ? 'Assessment' : "Lesson #{ld_metadata.lesson}"
    ].compact.join(' / ')
  end

  def grade
    ld_metadata.grade[/\d+/] || ld_metadata.grade
  end

  def ld_metadata
    @ld_metadata ||= DocTemplate::Objects::BaseMetadata.build_from(metadata)
  end

  def ld_module
    ela? ? ld_metadata.module : ld_metadata.unit
  end

  def ll_strand?
    ld_metadata.module =~ /strand/i
  end

  def math_practice
    ld_metadata.lesson_mathematical_practice.squish
  end

  def pdf_header
    "UnboundEd/#{full_breadcrumb}"
  end

  def pdf_filename(subtitle: '')
    "#{short_breadcrumb(join_with: '_', with_short_lesson: true)}#{subtitle}_v#{version.presence || 1}"
  end

  def pdf_footer
    full_breadcrumb
  end

  def short_breadcrumb(join_with: ' / ', with_short_lesson: false)
    lesson_abbr =
      if resource.try(:assessment?)
        with_short_lesson ? 'A' : 'Assessment'
      else
        with_short_lesson ? "L#{ld_metadata.lesson}" : "Lesson #{ld_metadata.lesson}"
      end
    [
      SUBJECT_FULL[subject] || subject,
      grade.to_i.zero? ? grade : "G#{grade}",
      ll_strand? ? 'LL' : "M#{ld_module.try(:upcase)}",
      topic.present? ? "#{TOPIC_SHORT[subject]}#{topic.try(:upcase)}" : nil,
      lesson_abbr
    ].compact.join(join_with)
  end

  def short_title
    "Lesson #{ld_metadata.lesson}"
  end

  def short_url
    @short_url ||= Bitly.client
                     .shorten(Rails.application.routes.url_helpers.lesson_document_url(self))
                     .short_url
  end

  def standards
    ld_metadata.standard || ld_metadata.lesson_standard
  end

  def subject
    ld_metadata.try(:resource_subject)
  end

  def subject_to_str
    SUBJECT_FULL[subject] || subject
  end

  def title
    ld_metadata.try(:title)
  end

  def teaser
    ld_metadata.teaser
  end

  def topic
    ela? ? ld_metadata.unit : ld_metadata.topic
  end
end
