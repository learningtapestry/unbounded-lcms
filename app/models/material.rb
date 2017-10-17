# frozen_string_literal: true

class Material < ActiveRecord::Base
  include PgSearch

  validates :file_id, presence: true
  validates :identifier, uniqueness: true

  has_many :material_parts, dependent: :delete_all
  has_and_belongs_to_many :documents

  serialize :metadata, DocTemplate::Objects::MaterialMetadata

  pg_search_scope :search_identifier, against: :identifier

  scope :gdoc, -> { where_metadata_not(type: 'pdf') }
  scope :pdf,  -> { where_metadata(type: 'pdf') }
  scope :where_metadata, ->(hash) { where('materials.metadata @> ?', hash.to_json) }
  scope :where_metadata_like, ->(key, val) { where('materials.metadata ->> ? ILIKE ?', key, "%#{val}%") }
  scope :where_metadata_not, ->(hash) { where.not('materials.metadata @> ?', hash.to_json) }

  def self.where_metadata_any_of(conditions)
    condition = Array.new(conditions.size, 'materials.metadata @> ?').join(' or ')
    where(condition, *conditions.map(&:to_json))
  end

  def file_url
    "https://docs.google.com/#{pdf? ? 'file' : 'document'}/d/#{file_id}"
  end

  def layout(context_type)
    # TODO: Move to concern with the same method in `Document`
    material_parts.where(part_type: :layout, context_type: DocumentPart.context_types[context_type.to_sym]).last
  end

  def pdf?
    metadata.type.casecmp('pdf').zero?
  end

  def source_type
    pdf? ? 'pdf' : 'gdoc'
  end
end
