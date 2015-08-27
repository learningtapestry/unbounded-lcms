module Content
  module Models
    class DocumentAlignment < ActiveRecord::Base
      belongs_to :document
      belongs_to :alignment
    end
  end
end
