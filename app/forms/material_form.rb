# frozen_string_literal: true

require 'doc_template'

class MaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  attribute :source_type, String, default: 'gdoc'
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
    service = MaterialBuildService.new(@credentials)
    @material = source_type == 'pdf' ? service.build_from_pdf(link) : service.build_from_gdoc(link)
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
