module Content
  module Models
    class DocumentLanguage < ActiveRecord::Base
      belongs_to :document
      belongs_to :language
    end
  end
end
