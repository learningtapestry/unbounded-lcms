class ReadingAssignmentText < ActiveRecord::Base
  has_many :resources
  belongs_to :reading_assignment_author
end
