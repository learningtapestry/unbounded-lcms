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
    return false unless valid?

    persist!
    errors.empty? # returns false if there were errors during the import
  end

  private

  def persist!
    @lesson = DocumentDownloader::GDoc
                .new(@credentials, link, @target_klass)
                .import

    parsed_document = DocTemplate::Template.parse @lesson.original_content

    @lesson.update!(
      activity_metadata: parsed_document.activity_metadata,
      css_styles: parsed_document.css_styles,
      content: parsed_document.render,
      foundational_metadata: parsed_document.foundational_metadata,
      metadata: parsed_document.metadata,
      toc: parsed_document.toc
    )

    @lesson.activate!

    LessonGenerateDocxJob.perform_later @lesson
    LessonGeneratePdfJob.perform_later @lesson
  rescue => e
    Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
    errors.add(:link, e.message)
    raise
  end
end
