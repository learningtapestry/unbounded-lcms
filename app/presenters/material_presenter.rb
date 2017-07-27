# frozen_string_literal: true

class MaterialPresenter < PDFPresenter
  attr_reader :lesson
  delegate :css_styles, :short_url, :subject, to: :lesson
  delegate :sheet_type, :vertical_text, to: :metadata

  def cc_attribution
    lesson.ld_metadata.cc_attribution
  end

  def full_breadcrumb
    lesson.full_breadcrumb(unit_level: unit_level?)
  end

  def header?
    config[:header]
  end

  def header_breadcrumb
    short_breadcrumb = lesson.short_breadcrumb(join_with: '/', unit_level: unit_level?,
                                               with_short_lesson: true, with_subject: false)
    short_title = unit_level? ? lesson.title : lesson.resource&.parent&.title
    "#{lesson.subject.upcase} #{short_breadcrumb} #{short_title}"
  end

  def orientation
    config[:orientation]
  end

  def pdf_filename
    name = metadata.identifier
    unless name =~ /^(math|ela)/i
      name = "#{lesson.short_breadcrumb(join_with: '_', with_short_lesson: true)}_#{name}"
    end
    "documents/#{lesson.id}/#{name}_v#{version.presence || 1}"
  end

  def pdf_type
    metadata.type
  end

  def student_material?
    metadata.sheet_type == 'student'
  end

  def subtitle
    config[:subtitle][sheet_type.to_sym] if config.key?(:subtitle)
  end

  def teacher_material?
    !student_material?
  end

  def title
    metadata.title.presence || config[:title]
  end

  def unit_level?
    metadata.breadcrumb_level == 'unit'
  end
end
