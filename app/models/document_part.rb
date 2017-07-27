class DocumentPart < ActiveRecord::Base
  belongs_to :document

  default_scope { active }

  scope :active, -> { where(active: true) }
end
