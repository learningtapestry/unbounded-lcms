# frozen_string_literal: true

class Resource < ActiveRecord::Base # rubocop:disable Metrics/ClassLength
  enum resource_type: {
    resource: 1,
    podcast: 2,
    video: 3,
    quick_reference_guide: 4,
    text_set: 5
  }
  MEDIA_TYPES = %i(video podcast).map { |t| resource_types[t] }.freeze
  GENERIC_TYPES = %i(text_set quick_reference_guide).map { |t| resource_types[t] }.freeze

  SUBJECTS = %w(ela math lead).freeze
  HIERARCHY = %i(subject grade module unit lesson).freeze

  include Searchable
  include Navigable

  mount_uploader :image_file, ResourceImageUploader

  acts_as_taggable_on :content_sources, :download_types, :resource_types, :tags, :topics
  has_closure_tree order: :level_position, dependent: :destroy

  belongs_to :parent, class_name: 'Resource', foreign_key: 'parent_id'

  # Additional resources
  has_many :resource_additional_resources, dependent: :destroy
  has_many :additional_resources, through: :resource_additional_resources

  # Standards.
  has_many :resource_standards, dependent: :destroy
  has_many :standards, through: :resource_standards
  has_many :common_core_standards, -> { where(type: 'CommonCoreStandard') },
           source: :standard, through: :resource_standards
  has_many :unbounded_standards, -> { where(type: 'UnboundedStandard') },
           source: :standard, through: :resource_standards

  # Downloads.
  has_many :resource_downloads, dependent: :destroy
  has_many :downloads, through: :resource_downloads
  accepts_nested_attributes_for :resource_downloads, allow_destroy: true

  # Curriculums.
  has_many :curriculums, as: :item, dependent: :destroy

  # Reading assignments.
  has_many :resource_reading_assignments, dependent: :destroy
  alias_attribute :reading_assignments, :resource_reading_assignments
  has_many :reading_assignment_texts, through: :resource_reading_assignments

  # Related resources.
  has_many :resource_related_resources, dependent: :destroy
  has_many :related_resources, through: :resource_related_resources, class_name: 'Resource'
  has_many :resource_related_resources_as_related,
           class_name: 'ResourceRelatedResource',
           foreign_key: 'related_resource_id',
           dependent: :destroy

  # Requirements
  has_many :resource_requirements, dependent: :destroy
  has_many :requirements, through: :resource_requirements

  has_many :content_guides, through: :unbounded_standards
  has_many :copyright_attributions, dependent: :destroy
  has_many :social_thumbnails, as: :target
  has_many :documents, dependent: :destroy

  has_many :document_bundles, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true, url: true, if: %i(video? podcast?)

  scope :tree, -> { where(tree: true) }
  scope :where_curriculum, ->(*dir) { where('curriculum_directory @> ?', "{#{dir.join(',')}}") }
  scope :where_curriculum_in, lambda { |arr, constraints = nil|
    arr = Array.wrap(arr)
    arr &= constraints if constraints
    arr.empty? ? where(nil) : where('curriculum_directory && ?', "{#{arr.join(',')}}")
  }
  scope :where_grade, ->(grades) { where_curriculum_in(grades, Grades::GRADES) }
  scope :where_subject, ->(subjects) { where_curriculum_in(subjects, SUBJECTS) }
  scope :media, -> { where(resource_type: MEDIA_TYPES) }
  scope :generic_resources, -> { where(resource_type: GENERIC_TYPES) }
  scope :ordered, -> { order(:hierarchical_position, :title) }

  before_save :update_curriculum_tags, :update_slug, :update_position
  after_save :update_descendants_tags, :update_descendants_position, :update_descendants_tree
  before_destroy :destroy_additional_resources

  class << self
    # Define dynamic scopes for hierarchy levels.
    # I,e: `grades`, `units`, etc
    HIERARCHY.map(&:to_s).each do |level|
      define_method(:"#{level.pluralize}") { where(curriculum_type: level) }
    end

    def find_by_curriculum(curr)
      curr = curr.select(&:present?)
      type = HIERARCHY[curr.size - 1]
      tree.where_curriculum(curr).where(curriculum_type: type).first
    end

    def find_podcast_by_url(url)
      podcast.where(url: url).first
    end

    def find_video_by_url(url)
      video_id = MediaEmbed.video_id(url)
      video.where("url ~ '#{video_id}(&|$)'").first
    end

    # used for ransack search on the admin
    def ransackable_scopes(_auth_object = nil)
      %i(grades)
    end
  end

  # Define predicate methods for subjects.
  # I,e: #ela?, #math?, ..
  SUBJECTS.each do |subject_name|
    define_method(:"#{subject_name}?") { subject == subject_name.to_s }
  end

  # Define predicate methods for hierarchy levels.
  # I,e: #subject?, #grade?, #lesson?, ...
  HIERARCHY.each do |level|
    define_method(:"#{level}?") { curriculum_type.present? && curriculum_type.casecmp(level.to_s).zero? }
  end

  def assessment?
    curriculum.grep(/assessment/).any?
  end

  def media?
    %w(video podcast).include? resource_type
  end

  def generic?
    %w(text_set quick_reference_guide).include?(resource_type)
  end

  # `Optional prerequisite` - https://github.com/learningtapestry/unbounded/issues/557
  def opr?
    tag_list.include?('opr')
  end

  def prerequisite?
    tag_list.include?('prereq')
  end

  def curriculum
    @curriculum ||= HIERARCHY.map do |key|
      key == :grade ? grades.average(abbr: false) : curriculum_tags_for(key).first
    end.compact
  end

  def curriculum_tags_for(type)
    case type.to_sym
    when :subject
      curriculum_directory & SUBJECTS
    when :grade
      curriculum_directory & Grades::GRADES
    when :module
      # TODO: handle special case modules (when/if needed).
      #       Check Breadcrumbs#module_abbrv for more
      curriculum_directory.select { |v| v.match(/module /i) || v.match(/strand/i) }
    when :unit
      curriculum_directory.select { |v| v.match(/unit|topic|assessment/i) }
    when :lesson
      curriculum_directory.select { |v| v.match(/lesson|part/i) }
    end.uniq.compact
  end

  def subject
    curriculum_tags_for(:subject).first
  end

  def grades
    Grades.new(self)
  end

  def grades=(gds)
    curriculum_directory.concat Array.wrap(gds)
  end

  def related_resources
    @related_resources ||= resource_related_resources
                             .includes(:related_resource)
                             .order(:position)
                             .map(&:related_resource)
  end

  def download_categories
    categories =
      {}.tap do |data|
        DownloadCategory.pluck(:description, :long_description, :title).each do |x|
          next unless download_categories_settings[x[2].parameterize]&.values&.any?
          data[x[2]] = [OpenStruct.new(long: x[1], short: x[0])]
        end
      end

    downloads = resource_downloads
                  .sort_by { |rd| rd.download_category&.position }
                  .group_by { |d| d.download_category&.title.to_s }
                  .transform_values { |v| v.sort_by { |d| [d.download.main ? 0 : 1, d.download.title] } }

    categories.merge downloads
  end

  def pdf_downloads?
    downloads.any? { |d| d.attachment_content_type == 'pdf' }
  end

  def bilingual_standards
    standards.bilingual.distinct.order(:name)
  end

  alias do_not_skip_indexing? should_index?
  def should_index?
    do_not_skip_indexing? && (tree? || media? || generic?)
  end

  def named_tags
    {
      keywords: (tag_list + topic_list).compact.uniq,
      resource_type: resource_type,
      ell_appropriate: ell_appropriate,
      ccss_standards: tag_standards,
      ccss_domain: nil, # resource.standards.map { |std| std.domain.try(:name) }.uniq
      ccss_cluster: nil, #  resource.standards.map { |std| std.cluster.try(:name) }.uniq
      authors: reading_assignment_texts.map { |t| t.author.try(:name) }.compact.uniq,
      texts: reading_assignment_texts.map(&:name).uniq
    }
  end

  def filtered_named_tags
    filtered_named_tags = named_tags
    stds = named_tags[:ccss_standards].map { |n| Standard.filter_ccss_standards(n, subject) }.compact
    filtered_named_tags.merge(ccss_standards: stds)
  end

  def tag_standards
    common_core_standards.map(&:alt_names).flatten.uniq
  end

  def copyrights
    copyright_attributions
  end

  def document
    documents.actives.order(updated_at: :desc).first
  end

  def document?
    document.present?
  end

  def next_hierarchy_level
    index = HIERARCHY.index(curriculum_type.to_sym)
    HIERARCHY[index + 1]
  end

  def unit_bundles?
    unit? && document_bundles.any?
  end

  def update_curriculum_tags
    new_dir = curriculum_directory

    # add all parents short_title to the curriculum
    new_dir += parents_tags(parent).compact.reverse if parent_id

    # change self tag if short_title has changed
    new_dir = new_dir - [short_title_was] + [short_title] if short_title_changed?

    self.curriculum_directory = new_dir.select(&:present?).uniq
  end

  def update_position
    self.hierarchical_position = HierarchicalPosition.new(self).position
  end

  private

  def destroy_additional_resources
    ResourceAdditionalResource.where(additional_resource_id: id).destroy_all
  end

  def parents_tags(node)
    node ? [node.short_title, *parents_tags(node.parent)] : []
  end

  def update_descendants_tags
    # update only if is not a lesson (no descendants) and short_title has changed
    return unless !lesson? && short_title_changed?

    descendants.each do |r|
      new_dir = r.curriculum_directory - [short_title_was] + [short_title]
      r.curriculum_directory = new_dir.uniq.compact
      r.save
    end
  end

  def update_descendants_position
    # update only if is not a lesson (no descendants) and level_position has changed
    return unless !lesson? && level_position_changed?

    descendants.each { |r| r.update_position && r.save }
  end

  def update_descendants_tree
    # update only if is not a lesson (no descendants) and `tree` has changed to false
    return unless !lesson? && tree_changed? && !tree?

    descendants.each { |r| (r.tree = false) && r.save }
  end

  def update_slug
    self.slug = Slug.new(self).value
  end
end
