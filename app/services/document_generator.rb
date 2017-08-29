# frozen_string_literal: true

class DocumentGenerator
  CONTENT_TYPES = %w(full tm sm).freeze

  class << self
    def documents(document)
      # NOTE: Temporary disable DOCX generation - need to solve
      # few issues on the server side
      # LessonGenerateDocxJob.perform_later document
      CONTENT_TYPES.each do |type|
        LessonGenerateGdocJob.perform_later document, content_type: type
        LessonGeneratePdfJob.perform_later document, content_type: type
      end
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
      CONTENT_TYPES.each do |type|
        keys = [DocumentExporter::PDF::Base.pdf_key(type), DocumentExporter::Gdoc::Base.gdoc_key(type)]
        keys.each { |key| document.links.delete(key) }
      end
      document.save
    end
  end
end
