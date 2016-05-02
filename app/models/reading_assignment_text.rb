class ReadingAssignmentText < ActiveRecord::Base
  has_many :resources
  belongs_to :reading_assignment_author
  alias_attribute :author, :reading_assignment_author
end
