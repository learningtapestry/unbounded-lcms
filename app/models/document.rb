# frozen_string_literal: true

class Document < ActiveRecord::Base
  belongs_to :resource
  has_many :document_parts, dependent: :delete_all
  has_and_belongs_to_many :materials

  before_save :clean_curriculum_metadata
  before_save :set_resource_from_metadata

  store_accessor :foundational_metadata
  store_accessor :metadata
  serialize :toc, DocTemplate::Objects::TOCMetadata

  scope :actives,   -> { where(active: true) }
  scope :inactives, -> { where(active: false) }

  scope :where_metadata, ->(key, val) { where('metadata @> hstore(:key, :val)', key: key, val: val) }

  scope :order_by_curriculum, lambda {
    keys = %i(subject grade module unit topic lesson)
    order(keys.map { |k| "documents.metadata -> '#{k}'" }.join(', '))
  }

  scope :filter_by_term, lambda { |search_term|
    term = "%#{search_term}%"
    joins(:resource).where('resources.title ILIKE ? OR name ILIKE ?', term, term)
  }

  scope :filter_by_subject, ->(subject) { where_metadata(:subject, subject) }

  scope :filter_by_grade, ->(grade) { where_metadata(:grade, grade) }

  def activate!
    self.class.transaction do
      # deactive all other lessons for this resource
      self.class.where(resource_id: resource_id).where.not(id: id).update_all active: false
      # activate this lesson. PS: use a simple sql update, no callbacks
      update_columns active: true
    end
  end

  def assessment?
    resource&.assessment?
  end

  def ela?
    metadata['subject'].to_s.casecmp('ela').zero?
  end

  def file_url
    return unless file_id.present?
    "https://docs.google.com/document/d/#{file_id}"
  end

  def file_fs_url
    return unless foundational_file_id.present?
    "https://docs.google.com/document/d/#{foundational_file_id}"
  end

  def foundational?
    metadata['type'].to_s.casecmp('fs').zero?
  end

  def gdoc_material_ids
    materials.gdoc.pluck(:id)
  end

  def layout(context_type)
    # TODO: Move to concern with the same method in `Material`
    document_parts.where(part_type: :layout, context_type: DocumentPart.context_types[context_type.to_sym]).last
  end

  def materials_anchors
    {}.tap do |materials_with_anchors|
      toc.children.each do |x|
        x.material_ids.each do |m|
          materials_with_anchors[m] ||= { optional: [], anchors: [] }
          materials_with_anchors[m][x.optional ? :optional : :anchors] << x.anchor
        end
      end

      toc.children.flat_map(&:children).each do |x|
        x.material_ids.each do |m|
          materials_with_anchors[m] ||= { optional: [], anchors: [] }
          materials_with_anchors[m][x.optional ? :optional : :anchors] << x.anchor
        end
      end
    end
  end

  def math?
    metadata['subject'].to_s.casecmp('math').zero?
  end

  def ordered_material_ids
    if ela?
      agenda_metadata&.flat_map do |x|
        ids = x['metadata']['material_ids'] || []
        ids.concat x['children']&.flat_map { |c| c['metadata']['material_ids'] }
      end
    else
      ids = sections_metadata&.flat_map { |s| s['material_ids'] } || []
      ids.concat activity_metadata&.flat_map { |x| x['material_ids'] }
    end.compact
  end

  def tmp_link(key)
    url = links[key]
    with_lock do
      reload.links.delete(key)
      update links: links
    end
    url
  end

  private

  def clean_curriculum_metadata
    return unless metadata.present?

    # downcase subjects
    metadata['subject'] = metadata['subject']&.downcase

    /(\d+)/.match(metadata['grade']) do |m|
      metadata['grade'] = "grade #{m[1]}"
    end

    # store only the lesson number
    # or alphanumeric - needed by OPR type, see https://github.com/learningtapestry/unbounded/issues/557
    lesson = metadata['lesson']
    metadata['lesson'] = lesson.match(/lesson (\w+)/i).try(:[], 1) || lesson if lesson.present?
  end

  def set_resource_from_metadata
    return unless metadata.present?

    resource = MetadataContext.new(metadata).find_or_create_resource

    # Update resource with document metadata
    resource.title = metadata['title'] if metadata['title'].present?
    resource.teaser = metadata['teaser'] if metadata['teaser'].present?
    resource.description = metadata['description'] if metadata['description'].present?
    resource.tag_list << 'prereq' if metadata['type'].to_s.casecmp('prereq').zero?
    resource.tag_list << 'opr' if metadata['type'].to_s.casecmp('opr').zero?
    resource.save

    self.resource_id = resource.id
  end
end
