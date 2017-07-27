class LDPdfContent
  STUDENT_SM_TAGS = {
    'ela'  => %w(assess et js photo rubric sh ela2-sm).map { |t| ".o-ld-ela-#{t}" },
    'math' => %w(.o-ld-materials)
  }.freeze

  def self.generate(document, pdf_type: 'full')
    content = document.render_lesson
    return content unless pdf_type == 'sm'
    sm_selector = STUDENT_SM_TAGS[document.subject].join(',')
    Nokogiri::HTML(content).css(sm_selector)
  end
end
