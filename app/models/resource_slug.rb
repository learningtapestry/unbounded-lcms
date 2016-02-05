class ResourceSlug < ActiveRecord::Base
  belongs_to :resource
  belongs_to :resource_collection

  validates :resource, :value, presence: true
  validates :value, uniqueness: { case_sensitive: false, scope: :resource_collection }
end
