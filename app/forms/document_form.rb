# frozen_string_literal: true

require 'doc_template'

class DocumentForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  validates :link, presence: true

  attr_accessor :document

  def initialize(target_klass, attributes = {}, google_credentials = nil)
    super(attributes)
    @credentials = google_credentials
    @target_klass = target_klass
  end

  def save
    return false unless valid?

    persist!
    errors.empty? # returns false if there were errors during the import
  end

  private

  def collect_materials(parsed_document)
    activity_ids = parsed_document
                     .activity_metadata.map { |a| a['material_ids'] }
                     .flatten.compact

    meta_ids = [].tap do |res|
      parsed_document.agenda.each do |x|
        x[:children].each { |a| res << a[:metadata]['material_ids'] }
      end
    end.compact.flatten

    activity_ids.concat(meta_ids).uniq
  end

  def persist!
    @document = DocumentDownloader::GDoc
                  .new(@credentials, link, @target_klass)
                  .import

    parsed_document = DocTemplate::Template.parse @document.original_content

    @document.update!(
      activity_metadata: parsed_document.activity_metadata,
      agenda_metadata: parsed_document.agenda,
      css_styles: parsed_document.css_styles,
      content: parsed_document.render,
      foundational_metadata: parsed_document.foundational_metadata,
      material_ids: collect_materials(parsed_document),
      metadata: parsed_document.metadata,
      toc: parsed_document.toc
    )

    # avoid duplication by deleting all the parts of a document first
    # TODO: this must change when we introduce layouts and composition where a
    # part does not related to a document but to a layout which is then related
    # to a document
    @document.document_parts.delete_all

    parsed_document.parts.each do |part|
      @document.document_parts.create!(
        active: true,
        content: part[:content],
        part_type: part[:part_type],
        placeholder: part[:placeholder]
      )
    end

    @document.activate!

    # NOTE: Temporary disable DOCX generation - need to solve
    # few issues on the server side
    # LessonGenerateDocxJob.perform_later @document
    LessonGeneratePdfJob.perform_later @document, pdf_type: 'full'
    LessonGeneratePdfJob.perform_later @document, pdf_type: 'sm'
    LessonGeneratePdfJob.perform_later @document, pdf_type: 'tm'
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
