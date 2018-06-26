# frozen_string_literal: true

class Author < ActiveRecord::Base
  has_many :resources
  has_many :curriculums, -> { distinct }, through: :resources
end
