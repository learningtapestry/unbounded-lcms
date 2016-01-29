module Content
  module Models
    class LobjectDownload < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
      belongs_to :download
      belongs_to :download_category

      validates :download, presence: true

      accepts_nested_attributes_for :download
    end
  end
end
