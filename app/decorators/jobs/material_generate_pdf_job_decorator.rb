# frozen_string_literal: true

MaterialGeneratePDFJob.class_eval do
  def material_presenter(material, document)
    MaterialPresenter.new material, lesson: DocumentPresenter.new(document)
  end

  def links_from_metadata(material)
    { 'url' => material.metadata.pdf_url, 'thumb' => material.metadata.thumb_url }
  end
end
