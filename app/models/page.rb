class Page < ActiveRecord::Base
  validates :body, :title, :slug, presence: true

  def full_title
    "UnboundEd - #{title}"
  end
end
