class ContentGuideFaq < ActiveRecord::Base
  validates :title, :description, :subject, :heading, :subheading, presence: true
  validates :subject, uniqueness: { scope: :active }

  scope :where_subject, ->(subject) { where(active: true).where(subject: subject) }
end
