class Page < ActiveRecord::Base
  validates :body, :title, :slug, presence: true
end
