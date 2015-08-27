require 'content/models/concerns/canonicable'

module Content
  module Models
    class Url < ActiveRecord::Base
      include Canonicable
      
      has_many :lobject_urls, dependent: :destroy
      has_many :lobjects, through: :lobject_urls

      scope :stale, -> (reference_date = nil) {
        if reference_date
          canonicals.where('checked_at is NULL or checked_at <= ?', DateTime.now - reference_date)
        else
          canonicals.where('checked_at is NULL')
        end
      }
    end
  end
end
