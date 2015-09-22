module Content
  module Models
    class Page < ActiveRecord::Base
      validates :body, :title, :slug, presence: true
    end
  end
end
