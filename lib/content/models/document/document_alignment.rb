module Content
  class DocumentAlignment < ActiveRecord::Base
    belongs_to :document
    belongs_to :alignment
  end
end
