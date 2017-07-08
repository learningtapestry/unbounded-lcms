class Material < ActiveRecord::Base
  validates :file_id, presence: true

  scope :where_metadata, ->(hash) { where('metadata @> ?', hash.to_json) }

  def file_url
    "https://docs.google.com/document/d/#{file_id}"
  end
end
