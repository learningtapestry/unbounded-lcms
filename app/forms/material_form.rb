# frozen_string_literal: true

require 'doc_template'

class MaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  attribute :source_type, String, default: 'gdoc'
  validates :link, presence: true

  attr_accessor :material

  def initialize(attributes = {}, google_credentials = nil, opts = {})
    super(attributes)
    @credentials = google_credentials
    @options = opts
  end

  def save
    return false unless valid?

    persist!

    result = errors.empty? && material&.valid?
    material.update preview_links: {} if result
    result
  end

  private

  attr_reader :options

  # TODO: Need to rename to `persist` as we do not raise error here
  def persist!
    service = MaterialBuildService.new(@credentials, import_retry: options[:import_retry])
    @material = source_type == 'pdf' ? service.build_from_pdf(link) : service.build_from_gdoc(link)
  rescue StandardError => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
