class LessonDocumentForm < Reform::Form
  property :link
  property :credentials

  validates :link, presence: true
  validates :credentials, presence: true

  def save
    DocumentDownloader::GDoc.new(
      credentials, link, LessonDocument
    ).import
  end
end
