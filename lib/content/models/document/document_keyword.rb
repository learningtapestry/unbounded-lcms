module Content
  module Models
    class DocumentKeyword < ActiveRecord::Base
      belongs_to :document
      belongs_to :keyword
    end
  end
end
