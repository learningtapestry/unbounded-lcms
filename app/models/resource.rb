class Resource < ActiveRecord::Base
  include Searchable
  include Navigable

  mount_uploader :image_file, ResourceImageUploader

  enum resource_type: {
    resource: 1,
    podcast: 2,
    video: 3,
    quick_reference_guide: 4,
    text_set: 5
  }
  MEDIA_TYPES = %i(video podcast).map { |t| resource_types[t] }.freeze
  GENERIC_TYPES = %i(text_set quick_reference_guide).map { |t| resource_types[t] }.freeze

  acts_as_taggable_on :content_sources, :download_types, :resource_types, :tags, :topics

  belongs_to :curriculum_tree

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

  has_many :documents

  validates :title, presence: true
  validates :url, presence: true, url: true, if: %i(video? podcast?)

  attr_accessor :skip_update_curriculum_tree

  accepts_nested_attributes_for :resource_downloads, allow_destroy: true

  before_save :update_curriculum_tree, :update_slug, :update_position
  before_destroy :destroy_additional_resources

  scope :tree, lambda { |name = nil|
    if name
      joins(:curriculum_tree).where(curriculum_tree: { name: name })
    else
      where(curriculum_tree_id: CurriculumTree.default.try(:id))
    end
  }

  scope :where_curriculum, ->(*dir) { where('curriculum_directory @> ?', "{#{dir.join(',')}}") }

  scope :where_curriculum_in, lambda { |arr, constraints = nil|
    arr = Array.wrap(arr)
    arr &= constraints if constraints

    arr.empty? ? where(nil) : where('curriculum_directory && ?', "{#{arr.join(',')}}")
  }

  scope :subjects, -> { where(curriculum_type: 'subject') }
  scope :grades, -> { where(curriculum_type: 'grade') }
  scope :modules, -> { where(curriculum_type: 'module') }
  scope :units, -> { where(curriculum_type: 'unit') }
  scope :lessons, -> { where(curriculum_type: 'lesson') }

  scope :media, -> { where(resource_type: MEDIA_TYPES) }
  scope :generic_resources, -> { where(resource_type: GENERIC_TYPES) }

  scope :where_subject, ->(subjects) { where_curriculum_in(subjects, CurriculumTree::SUBJECTS) }
  scope :where_grade, ->(grades) { where_curriculum_in(grades, Grades::GRADES) }

  scope :where_tag, lambda { |context, value|
    value = Array.wrap(value)
    return where(nil) unless value.any?

    joins(taggings: [:tag]).where(taggings: { context: context }, tags: { name: value })
  }

  scope :ordered, -> { order(:hierarchical_position, :title) }

  def self.create_from_curriculum(chain)
    type = CurriculumTree::HIERARCHY[chain.size - 1]
    res = where_curriculum(chain).where(curriculum_type: type).first
    return res if res.present?

    res = Resource.new(
      curriculum_directory: chain,
      curriculum_tree: CurriculumTree.default,
      curriculum_type: type,
      resource_type: :resource,
      short_title: chain.last,
      skip_update_curriculum_tree: true
    )
    res.title = Breadcrumbs.new(res).title.split(' / ')[0...-1].push(chain.last.titleize).join(' ')
    res.save!
    res
  end

  def self.find_podcast_by_url(url)
    podcast.where(url: url).first
  end

  def self.find_video_by_url(url)
    video_id = MediaEmbed.video_id(url)
    video.where("url ~ '#{video_id}(&|$)'").first
  end

  def self.find_by_curriculum(curr)
    type = CurriculumTree::HIERARCHY[curr.size - 1]
    tree.where_curriculum(curr).where(curriculum_type: type).first
  end

  # used for ransack search on the admin
  def self.ransackable_scopes(_auth_object = nil)
    %i(grades)
  end

  def tree?
    curriculum_tree_id.present? && curriculum_tree_id == CurriculumTree.default.try(:id)
  end

  def type_is?(type)
    curriculum_type.present? && curriculum_type.casecmp(type.to_s).zero?
  end

  # Define predicate methods for subjects.
  # I,e: #ela?, #math?, ..
  CurriculumTree::SUBJECTS.each do |subject_name|
    define_method(:"#{subject_name}?") { subject == subject_name.to_s }
  end

  # Define predicate methods for hierarchy levels.
  # I,e: #subject?, #grade?, #lesson?, ...
  CurriculumTree::HIERARCHY.each do |level|
    define_method(:"#{level}?") { type_is?(level) }
  end

  def assessment?
    # tag_list.include?('assessment')
    curriculum_tags_for(:lesson).include?('assessment')
  end

  def generic?
    %w(text_set quick_reference_guide).include?(resource_type)
  end

  def media?
    %w(video podcast).include? resource_type
  end

  def curriculum_tags_for(type)
    case type.to_sym
    when :subject
      curriculum_directory & CurriculumTree::SUBJECTS
    when :grade
      curriculum_directory & Grades::GRADES
    when :module
      # TODO: handle special case modules (when/if needed).
      #       Check Breadcrumbs#module_abbrv for more
      curriculum_directory.select { |v| v.match(/module /) }
    when :unit
      curriculum_directory.select { |v| v.match(/unit|topic /) }
    when :lesson
      curriculum_directory.select { |v| v.match(/lesson|part|assessment/) }
    end.uniq.compact
  end

  def curriculum
    @curriculum ||= CurriculumTree::HIERARCHY.map do |key|
      key == :grade ? grades.average(abbr: false) : curriculum_tags_for(key).first
    end.compact
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
    resource_downloads
      .group_by { |d| d.download_category.try(:category_name) || '' }
      .sort_by { |k, _| k }.to_h
      .transform_values { |v| v.sort_by { |d| [d.download.main ? 0 : 1, d.download.title] } }
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
    filtered_named_tags.merge(
      ccss_standards: named_tags[:ccss_standards]
                        .map { |n| Standard.filter_ccss_standards(n) }
                        .compact
    )
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

  private

  def destroy_additional_resources
    ResourceAdditionalResource.where(additional_resource_id: id).destroy_all
  end

  def update_curriculum_tree
    CurriculumTree.insert_branch_for(self) if update_tree?
  end

  def update_tree?
    !skip_update_curriculum_tree && tree? && curriculum.present?
  end

  def update_position
    self.hierarchical_position = HierarchicalPosition.new(self).position
  end

  def update_slug
    self.slug = Slug.new(self).value if tree?
  end
end
