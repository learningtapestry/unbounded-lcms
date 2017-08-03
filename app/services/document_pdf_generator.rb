# frozen_string_literal: true

class DocumentPdfGenerator
  class << self
    def documents(document)
      # NOTE: Temporary disable DOCX generation - need to solve
      # few issues on the server side
      # LessonGenerateDocxJob.perform_later document
      LessonGeneratePdfJob.perform_later document, pdf_type: 'full'
      LessonGeneratePdfJob.perform_later document, pdf_type: 'sm'
      LessonGeneratePdfJob.perform_later document, pdf_type: 'tm'
    end

    def documents_of(material)
      material.documents.each do |document|
        LessonGenerateMaterialsJob.perform_later document, material
      end
    end

    def materials_for(document)
      LessonGenerateMaterialsJob.perform_later document
    end
  end
end
