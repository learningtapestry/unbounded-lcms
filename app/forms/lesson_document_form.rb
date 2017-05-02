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
      true
    else
      false
    end
  end

  private

  def persist!
    @lesson = DocumentDownloader::GDoc.new(
      @credentials, link, @target_klass
    ).import

    @lesson.content = DocTemplate::Template.parse(
      @lesson.original_content
    ).render

    @lesson.save
  end
end
