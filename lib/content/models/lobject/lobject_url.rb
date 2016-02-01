module Content
  module Models
    class LobjectUrl < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :url

      accepts_nested_attributes_for :url, reject_if: ->(attrs) { attrs[:url].blank? }
    end
  end
end
