module Content
  module Models
    class DocumentDownload < ActiveRecord::Base
      belongs_to :document
      belongs_to :download
    end
  end
end
