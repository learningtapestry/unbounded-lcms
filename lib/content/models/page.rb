module Content
  module Models
    class Page < ActiveRecord::Base
      validates :body, :title, presence: true
    end
  end
end
