module Content
  module Models
    class DocumentAgeRange < ActiveRecord::Base
      belongs_to :document
    end
  end
end
