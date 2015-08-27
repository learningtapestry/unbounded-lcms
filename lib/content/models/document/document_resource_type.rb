module Content
  module Models
    class DocumentResourceType < ActiveRecord::Base
      belongs_to :document
      belongs_to :resource_type
    end
  end
end
