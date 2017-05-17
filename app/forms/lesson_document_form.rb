require 'doc_template'

class LessonDocumentForm
  include Virtus.model
  include ActiveModel::Model

  attribute :link, String
  validates :link, presence: true

  attr_accessor :lesson

  def initialize(target_klass, attributes = {}, google_credentials = nil)
    super(attributes)
    @credentials = google_credentials
    @target_klass = target_klass
  end

  def save
    if valid?
      persist!
      # returns false if there were errors during the import
      errors.empty?
    else
      false
    end
  end

  private

  def persist!
    begin
      @lesson = DocumentDownloader::GDoc.new(
        @credentials, link, @target_klass
      ).import

      parsed_document = DocTemplate::Template.parse(
        @lesson.original_content
      )

      # the parsed html document
      @lesson.content = parsed_document.render
      @lesson.metadata = parsed_document.metadata
      @lesson.activity_metadata = parsed_document.activity_metadata
      @lesson.foundational_metadata = parsed_document.foundational_metadata
      @lesson.toc = parsed_document.toc

      @lesson.save && @lesson.activate!
    rescue => e
      Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
      errors.add(:link, e.message)
      raise
    end
  end
end
