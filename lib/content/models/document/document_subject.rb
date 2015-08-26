module Content
  class DocumentSubject < ActiveRecord::Base
    belongs_to :document
    belongs_to :subject
  end
end
