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
    @document = DocumentDownloader::Gdoc
                  .new(@credentials, link, @target_klass)
                  .import

    parsed_document = DocTemplate::Template.parse @document.original_content

    @document.update!(
      activity_metadata: parsed_document.activity_metadata,
      agenda_metadata: parsed_document.agenda,
      css_styles: parsed_document.css_styles,
      foundational_metadata: parsed_document.foundational_metadata,
      material_ids: collect_materials(parsed_document),
      metadata: parsed_document.metadata,
      toc: parsed_document.toc
    )

    @document.document_parts.delete_all

    parsed_document.parts.each do |part|
      @document.document_parts.create!(
        active: true,
        anchor: part[:anchor],
        content: part[:content],
        context_type: part[:context_type],
        materials: part[:materials],
        part_type: part[:part_type],
        placeholder: part[:placeholder]
      )
    end

    @document.activate!

    DocumentGenerator.generate_for(@document)
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
  end
end
