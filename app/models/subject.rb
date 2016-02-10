class Subject < ActiveRecord::Base
  validates :name, presence: true

  default_scope { order(:name) }

  def self.ela
    find_by(name: 'english language arts')
  end

  def self.math
    find_by(name: 'math')
  end
end
