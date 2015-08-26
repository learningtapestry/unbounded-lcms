module Content
  class DocumentGrade < ActiveRecord::Base
    belongs_to :document
    belongs_to :grade
  end
end
