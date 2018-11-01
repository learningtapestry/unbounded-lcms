# frozen_string_literal: true

DocumentGenerateJob.class_eval do
  def create_gdoc_folders
    DocumentExporter::Gdoc::Base.new(document).create_gdoc_folders("#{document.id}_v#{document.version}")
  end

  def queue_documents
    DocumentGenerator::CONTENT_TYPES.each do |type|
      %w(DocumentGenerateGdocJob DocumentGeneratePdfJob).each do |klass|
        next if queued_or_running?(type, klass)
        klass.constantize.perform_later document, content_type: type
      end
    end
  end
end