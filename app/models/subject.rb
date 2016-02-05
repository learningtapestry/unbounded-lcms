class Subject < ActiveRecord::Base
  validates :name, presence: true

  default_scope { order(:name) }
end
