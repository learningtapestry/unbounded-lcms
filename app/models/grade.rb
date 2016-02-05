class Grade < ActiveRecord::Base
  validates :name, presence: true

  default_scope { order(:grade) }

  alias_attribute :name, :grade
end
