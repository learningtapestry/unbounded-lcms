module Content
  class DocumentKeyword < ActiveRecord::Base
    belongs_to :document
    belongs_to :keyword
  end
end
