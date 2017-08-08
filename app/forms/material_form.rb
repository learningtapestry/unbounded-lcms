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
    document = DocumentDownloader::GDoc.new(@credentials, link, Material)
    html = Nokogiri::HTML.fragment(document.content)
    if DocTemplate::Tables::MaterialMetadata.parse(html).data.present?
      @material = document.import
      parsed_document = DocTemplate::Template.parse(@material.original_content, type: :material)
      presenter = MaterialPresenter.new(@material, parsed_document: parsed_document)

      @material.update!(
        content: presenter.render_content,
        identifier: parsed_document.metadata['identifier'].downcase,
        metadata: parsed_document.meta_options[:metadata]
      )

      DocumentPdfGenerator.documents_of(material)
    else
      errors.add(:link, "Material metadata table not present!  (#{link})")
    end
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, "#{e.message}  (#{link})")
  end
end
