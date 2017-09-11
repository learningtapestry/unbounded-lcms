# frozen_string_literal: true

require 'doc_template'

class MaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  validates :link, presence: true

  attr_accessor :material

  def initialize(attributes = {}, google_credentials = nil)
    super(attributes)
    @credentials = google_credentials
  end

  def save
    return false unless valid?

    persist!
    errors.empty? && material&.valid?
  end

  private

  def persist!
    downloader = DocumentDownloader::Gdoc.new(@credentials, link)
    content = downloader.download.content
    parsed_document = DocTemplate::Template.parse(content, type: :material)

    @material =
      Material.find_or_create_by(file_id: downloader.file_id).tap do |m|
        m.identifier = parsed_document.metadata['identifier'].downcase
        m.metadata = parsed_document.meta_options(:default)[:metadata]
        m.original_content = content
        m.save
      end

    @material.material_parts.delete_all

    presenter = MaterialPresenter.new(@material, parsed_document: parsed_document)
    DocTemplate::CONTEXT_TYPES.each do |context_type|
      @material.material_parts.create!(
        active: true,
        content: presenter.render_content(context_type),
        context_type: context_type,
        part_type: :layout
      )
    end
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
