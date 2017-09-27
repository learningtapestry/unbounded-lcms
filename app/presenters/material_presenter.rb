# frozen_string_literal: true

class MaterialPresenter < ContentPresenter
  attr_reader :lesson, :parsed_document

  delegate :cc_attribution, :css_styles, :short_url, :subject, to: :lesson
  delegate :sheet_type, to: :metadata
  delegate :parts, to: :parsed_document

  DEFAULT_TITLE = 'Material'

  def base_filename
    name = metadata.identifier
    unless name =~ /^(math|ela)/i
      name = "#{lesson.short_breadcrumb(join_with: '_', with_short_lesson: true)}_#{name}"
    end
    "#{name}_v#{version.presence || 1}"
  end

  def content_for(context_type)
    layout(context_type)&.content
  end

  def full_breadcrumb
    lesson.full_breadcrumb(unit_level: unit_level?)
  end

  def gdoc_folder
    "#{lesson.id}_v#{lesson.version}"
  end

  def header?
    config[:header]
  end

  def header_breadcrumb
    short_breadcrumb = lesson.short_breadcrumb(join_with: '/', unit_level: unit_level?,
                                               with_short_lesson: true, with_subject: false)
    short_title = unit_level? ? lesson.resource&.parent&.title : lesson.title
    "#{lesson.subject.upcase} #{short_breadcrumb} #{short_title}"
  end

  def name_date?
    # toggle display of name-date row on the header
    # https://github.com/learningtapestry/unbounded/issues/422
    # Added the config definition for new types. If config says "NO", it's impossible to force-add the name-date field.
    # It's impossible only to remove it when config allows it
    !metadata.name_date.to_s.casecmp('no').zero? && config[:name_date]
  end

  def pdf_filename
    "documents/#{lesson.id}/#{base_filename}"
  end

  def content_type
    metadata.type
  end

  def render_content(context_type, excludes = [])
    render_part(layout_content(context_type), excludes)
  end

  def student_material?
    sheet_type == 'student'
  end

  def subtitle
    config.dig(:subtitle, sheet_type.to_sym).presence || DEFAULT_TITLE
  end

  def teacher_material?
    !student_material?
  end

  def title
    metadata.title.presence || config[:title].presence || DEFAULT_TITLE
  end

  def unit_level?
    metadata.breadcrumb_level == 'unit'
  end

  def vertical_text?
    metadata.vertical_text.present?
  end

  private

  def document_parts_index
    @document_parts_index ||= parts.map { |p| [p[:placeholder], { anchor: p[:anchor], content: p[:content] }] }.to_h
  end

  def layout_content(context_type)
    parts.find { |p| p[:part_type] == :layout && p[:context_type] == context_type }&.dig(:content) || ''
  end
end
