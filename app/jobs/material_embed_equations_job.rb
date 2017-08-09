class MaterialEmbedEquationsJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    DocumentPdfGenerator.documents_of(material)
  end

  def perform(material)
    material.update!(content: EmbedEquations.call(material.content))
  end
end
