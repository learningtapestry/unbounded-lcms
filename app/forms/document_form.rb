# frozen_string_literal: true

require 'doc_template'

class DocumentForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  attribute :link_fs, String

  validates_presence_of :link, if: -> { link_fs.blank? }
  validates_presence_of :link_fs, if: -> { link.blank? }

  attr_reader :document

  def initialize(attributes = {}, google_credentials = nil, opts = {})
    @is_reimport = attributes.delete(:reimport).present? || false
    super(attributes)
    @credentials = google_credentials
    @options = opts
  end

  def save
    return false unless valid?

    @document = build_document
    DocumentGenerator.generate_for(@document)
    @document.update(reimported: true)
  rescue StandardError => e
    @document&.update(reimported: false)
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
    false
  end

  private

  attr_reader :credentials, :is_reimport, :options

  def build_document
    service = DocumentBuildService.new(credentials, import_retry: options[:import_retry])

    if is_reimport
      doc = service.build_for(link)
      doc = service.build_for(link_fs, expand: true) if link_fs.present?
      doc
    elsif (full_doc = find_full_document)
      # if there is a document with the same file_id or foundational_file_id
      # we need to make full re-import to correctly handle expand process
      service.build_for(full_doc.file_url)
      service.build_for(full_doc.file_fs_url, expand: true)
    else
      service.build_for link
    end
  end

  def find_full_document
    id = DocumentDownloader::Gdoc.file_id_for link

    doc = Document.actives.find_by(file_id: id)
    return doc if doc&.foundational_file_id.present?

    doc = Document.actives.find_by(foundational_file_id: id)
    doc if doc&.file_id.present?
  end
end
