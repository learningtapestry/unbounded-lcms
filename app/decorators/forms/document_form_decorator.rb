# frozen_string_literal: true

require 'doc_template'

DocumentForm.class_eval do
  attr_reader :credentials, :is_reimport, :options

  def initialize(attributes = {}, google_credentials = nil, opts = {})
    @is_reimport = attributes.delete(:reimport).present? || false
    super(attributes)
    @credentials = google_credentials
    @options = opts
  end

  def document_build_service
    DocumentBuildService.new(credentials, import_retry: options[:import_retry])
  end

  def file_id
    DocumentDownloader::Gdoc.file_id_for link
  end
end