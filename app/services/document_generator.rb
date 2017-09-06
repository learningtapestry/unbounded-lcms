# frozen_string_literal: true

class DocumentGenerator
  CONTENT_TYPES = %w(full tm sm).freeze

  class << self
    def generate_for(document)
      reset_links document
      DocumentGenerateJob.perform_later(document)
    end

    private

    def reset_links(document)
      document.links['materials'] = {}
      CONTENT_TYPES.each do |type|
        [
          DocumentExporter::PDF::Base.pdf_key(type),
          DocumentExporter::Gdoc::Base.gdoc_key(type)
        ].each { |key| document.links.delete(key) }
      end
      document.save
    end
  end
end
