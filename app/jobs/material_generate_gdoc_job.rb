# frozen_string_literal: true

class MaterialGenerateGdocJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  def perform(material, document)
    document = DocumentPresenter.new document
    material = MaterialPresenter.new material, lesson: document

    gdoc = DocumentExporter::Gdoc::Material.new(material).export

    material.documents.each do |d|
      new_links = {
        'materials' => {
          material.id => { 'gdoc' => gdoc.url }
        }
      }

      d.with_lock do
        links = d.reload.links
        d.reload.update links: links.deep_merge(new_links)
      end
    end
  end
end
