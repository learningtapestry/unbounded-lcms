class DocumentEmbedEquationsJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    DocumentPdfGenerator.materials_for(job.arguments.first)
  end

  def perform(document)
    document.document_parts.each do |part|
      part.update!(content: EmbedEquations.call(part.content))
    end
  end
end
