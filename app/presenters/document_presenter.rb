# frozen_string_literal: true

class DocumentPresenter < BasePresenter
  PART_RE = /{{[^}]+}}/
  PDF_SUBTITLES = { full: '', sm: '_student_materials', tm: '_teacher_materials' }.freeze
  SUBJECT_FULL = { 'ela' => 'ELA', 'math' => 'Math' }.freeze
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

  def pdf_content(type, options = {})
    LDPdfContent.generate(self, type, options.delete(:excludes) || [])
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

  def render_lesson(excludes = [])
    render_part layout.content, excludes
  end

  def render_part(part_content, excludes = [])
    part_content.gsub(PART_RE) do |placeholder|
      next unless placeholder
      next if excludes.include?(placeholder.delete('{}'))
      next unless (subpart = document_parts_index[placeholder])
      render_part subpart.to_s, excludes
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
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

  private

  def document_parts_index
    @document_parts_index ||= document_parts.pluck(:placeholder, :content).to_h
  end
end
