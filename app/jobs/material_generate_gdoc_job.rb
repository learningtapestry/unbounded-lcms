# frozen_string_literal: true

class MaterialGenerateGdocJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  def perform(material, document)
    material = MaterialPresenter.new material, lesson: DocumentPresenter.new(document)

    gdoc = DocumentExporter::Gdoc::Material.new(material).export

    new_links = {
      'materials' => {
        material.id.to_s => { 'gdoc' => gdoc.url }
      }
    }

    document.with_lock do
      links = document.reload.links
      document.update links: links.deep_merge(new_links)
    end

    DocumentGenerateJob.perform_later(document, check_queue: true)
  end
end
