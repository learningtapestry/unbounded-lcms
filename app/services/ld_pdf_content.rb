class LDPdfContent
  STUDENT_SM_TAGS = {
    'ela'  => %w(assess et js photo rubric sh ela2-sm).map { |t| ".o-ld-ela-#{t}" },
    'math' => %w(.o-ld-materials)
  }.freeze

  def self.generate(lesson_document, pdf_type: 'full')
    return lesson_document.content unless pdf_type == 'sm'
    sm_selector = STUDENT_SM_TAGS[lesson_document.subject].join(',')
    Nokogiri::HTML(lesson_document.content).css(sm_selector)
  end
end
