# frozen_string_literal: true

class DocumentGenerateGdocJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  GDOC_EXPORTERS = {
    'full' => DocumentExporter::Gdoc::Document,
    'sm'   => DocumentExporter::Gdoc::StudentMaterial,
    'tm'   => DocumentExporter::Gdoc::TeacherMaterial
  }.freeze

  def perform(document, options)
    content_type = options[:content_type]
    document = DocumentPresenter.new document.reload, content_type: content_type
    gdoc = GDOC_EXPORTERS[content_type].new(document, options).export

    key = options[:excludes].present? ? options[:gdoc_folder] : document.gdoc_key

    document.with_lock do
      document.update links: document.reload.links.merge(key => gdoc.url)
    end

    return unless options[:bundle]

    # Re-generate all materials if full lesson has been requested
    GDOC_EXPORTERS.keys.reject { |x| x == content_type }.each do |type|
      GDOC_EXPORTERS[type].new(document, options).export
    end
  end
end
