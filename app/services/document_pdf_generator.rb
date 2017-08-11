# frozen_string_literal: true

class DocumentPdfGenerator
  PDF_TYPES = %w(full tm sm).freeze

  class << self
    def documents(document)
      # NOTE: Temporary disable DOCX generation - need to solve
      # few issues on the server side
      # LessonGenerateDocxJob.perform_later document
      PDF_TYPES.each { |type| LessonGeneratePdfJob.perform_later document, pdf_type: type }
    end

    def documents_of(material)
      material.documents.each do |document|
        LessonGenerateMaterialsJob.perform_later document, material
      end
    end

    def materials_for(document)
      reset_links document
      LessonGenerateMaterialsJob.perform_later document
    end

    private

    def reset_links(document)
      document.links['materials'] = {}
      PDF_TYPES.each do |type|
        key = DocumentExporter::PDF::BasePDF.pdf_key type
        document.links.delete(key)
      end
      document.save
    end
  end
end
