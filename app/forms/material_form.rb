# frozen_string_literal: true

require 'doc_template'

class MaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  attribute :source_type, String
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
    params = {
      import_retry: options[:import_retry],
      source_type: source_type.presence
    }.compact
    service = MaterialBuildService.new @credentials, params
    @material = service.build link
  rescue StandardError => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
