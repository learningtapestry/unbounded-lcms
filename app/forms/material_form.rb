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
    errors.empty? && material.valid?
  end

  private

  def persist!
    @material = DocumentDownloader::GDoc.new(@credentials, link, Material).import

    parsed_document = DocTemplate::Template.parse(@material.original_content, type: :material)

    @material.update!(
      content: parsed_document.render,
      metadata: parsed_document.metadata,
      identifier: parsed_document.metadata['identifier']
    )
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
