class ReadingAssignmentAuthor < ActiveRecord::Base
  has_many :reading_assignment_texts
end
