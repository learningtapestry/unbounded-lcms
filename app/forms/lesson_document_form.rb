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
      # add the metadata attributes
      @lesson.metadata = parsed_document.metadata
      # add activities metadata
      @lesson.update activity_metadata: parsed_document.activity_metadata
      # add toc
      @lesson.toc = parsed_document.toc

      @lesson.save
    rescue => e
      errors.add(:link, e.message)
    end
  end
end
