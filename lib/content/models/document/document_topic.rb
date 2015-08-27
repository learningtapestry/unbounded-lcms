module Content
  module Models
    class DocumentTopic < ActiveRecord::Base
      belongs_to :document
      belongs_to :topic
    end
  end
end
