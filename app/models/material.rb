# frozen_string_literal: true

class Material < ActiveRecord::Base
  include PgSearch

  validates :file_id, presence: true
  validates :identifier, uniqueness: true

  has_and_belongs_to_many :documents

  serialize :metadata, DocTemplate::Objects::MaterialMetadata

  pg_search_scope :search_identifier, against: :identifier

  scope :where_metadata, ->(hash) { where('materials.metadata @> ?', hash.to_json) }

  def self.where_metadata_any_of(conditions)
    condition = Array.new(conditions.size, 'materials.metadata @> ?').join(' or ')
    where(condition, *conditions.map(&:to_json))
  end

  def file_url
    "https://docs.google.com/document/d/#{file_id}"
  end
end
