module Content
  module Models
    class DocumentSubject < ActiveRecord::Base
      belongs_to :document
      belongs_to :subject
    end
  end
end
