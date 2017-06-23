class DocumentPresenter < BasePresenter
  SUBJECT_FULL = { 'ela' => 'ELA', 'math' => 'Math' }.freeze
  PDF_SUBTITLES = { full: '', sm: '_student_materials', tm: '_teacher_materials' }.freeze
  TOPIC_FULL   = { 'ela' => 'Unit', 'math' => 'Topic' }.freeze
  TOPIC_SHORT  = { 'ela' => 'U', 'math' => 'T' }.freeze

  def color_code
    "#{subject}-base"
  end

  def color_code_grade
    "#{subject}-#{grade}"
  end

  def description
    ld_metadata.lesson_objective.presence || ld_metadata.description
  end

  def doc_type
    assessment? ? 'assessment' : 'lesson'
  end

  def full_breadcrumb
    [
      SUBJECT_FULL[subject] || subject,
      grade.to_i.zero? ? grade : "Grade #{grade}",
      ll_strand? ? ld_module : "Module #{ld_module.try(:upcase)}",
      topic.present? ? "#{TOPIC_FULL[subject]} #{topic.try(:upcase)}" : nil,
      assessment? ? 'Assessment' : "Lesson #{ld_metadata.lesson}"
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

  def pdf_content(pdf_type:)
    LDPdfContent.generate(self, pdf_type: pdf_type)
  end

  def pdf_header
    "UnboundEd / #{full_breadcrumb}"
  end

  def pdf_filename(type:)
    name = short_breadcrumb(join_with: '_', with_short_lesson: true)
    name += PDF_SUBTITLES[type.to_sym]
    "#{name}_v#{version.presence || 1}.pdf"
  end

  def pdf_footer
    full_breadcrumb
  end

  def short_breadcrumb(join_with: ' / ', with_short_lesson: false)
    lesson_abbr =
      if assessment?
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
    assessment? ? doc_type : "Lesson #{ld_metadata.lesson}"
  end

  def short_url
    @short_url ||= Bitly.client
                     .shorten(Rails.application.routes.url_helpers.document_url(self))
                     .short_url
  end

  def standards
    ld_metadata.standard.presence || ld_metadata.lesson_standard
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

  def render_part(part)
    rendered = part.content
    while rendered.count('{{') > 0
      rendered.sub!(/\{\{.+\}\}/) do |match|
        placeholder = match.match(/[^\{\}]+/)[0]
        subpart = document_parts.find_by(placeholder: placeholder, active: true)
        subpart.try(:content).presence || ''
      end
    end
    rendered
  end

  def render_teacher_materials
    sources = document_parts.where(part_type: :source)
    sources.inject('') do |rendered, part|
      rendered << render_part(part)
    end
  end

  def render_student_materials
    materials = document_parts.where(part_type: :materials)
    materials.inject('') do |rendered, part|
      rendered << render_part(part)
    end
  end

  def render_lesson
    # a layout can be anywhere and anything that includes placeholders
    layout = document_parts.find_by(part_type: :layout)
    render_part(layout)
  end
end
