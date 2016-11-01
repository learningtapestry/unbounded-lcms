class DownloadCategory < ActiveRecord::Base
  has_many :resource_downloads

  validates :name, uniqueness: true, presence: true

  def category_name
    description || name
  end
end
