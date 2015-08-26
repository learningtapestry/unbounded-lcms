module Content
  class DocumentDownload < ActiveRecord::Base
    belongs_to :document
    belongs_to :download
  end
end
