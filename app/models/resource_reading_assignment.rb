# frozen_string_literal: true

class ResourceReadingAssignment < ActiveRecord::Base
  belongs_to :reading_assignment_text
  belongs_to :resource
end
