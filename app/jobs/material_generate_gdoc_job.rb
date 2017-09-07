# frozen_string_literal: true

class MaterialGenerateGdocJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  after_perform do |job|
    DocumentGenerateJob.perform_later(job.arguments.second, check_queue: true)
  end

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
  end
end
