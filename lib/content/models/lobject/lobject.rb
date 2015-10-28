require 'content/models/concerns/searchable'
require 'nokogiri'

module Content
  module Models
    class Lobject < ActiveRecord::Base

      # Additonal lobjects
      has_many :lobject_additional_lobjects, dependent: :destroy
      has_many :additional_lobjects, through: :lobject_additional_lobjects

      # Age ranges.
      has_many :lobject_age_ranges, dependent: :destroy
      alias_attribute :age_ranges, :lobject_age_ranges

      # Conformed documents.
      has_many :lobject_documents, dependent: :destroy
      has_many :documents, through: :lobject_documents

      # Identities.
      has_many :lobject_identities, dependent: :destroy
      has_many :identities, through: :lobject_identities

      # Subjects.
      has_many :lobject_subjects, dependent: :destroy
      has_many :subjects, through: :lobject_subjects

      # Topics.
      has_many :lobject_topics, dependent: :destroy
      has_many :topics, through: :lobject_topics

      # Alignments.
      has_many :lobject_alignments, dependent: :destroy
      has_many :alignments, through: :lobject_alignments

      # Urls.
      has_many :lobject_urls, dependent: :destroy
      has_many :urls, through: :lobject_urls

      # Titles and descriptions.
      has_many :lobject_titles, -> { order(doc_created_at: :desc) }, dependent: :destroy
      has_many :lobject_descriptions, -> { order(doc_created_at: :desc) }, dependent: :destroy

      # Languages.
      has_many :languages, through: :lobject_languages
      has_many :lobject_languages, dependent: :destroy

      # Resource types.
      has_many :lobject_resource_types, dependent: :destroy
      has_many :resource_types, through: :lobject_resource_types

      # Downloads.
      has_many :lobject_downloads, dependent: :destroy
      has_many :downloads, through: :lobject_downloads

      # Grades.
      has_many :lobject_grades, dependent: :destroy
      has_many :grades, through: :lobject_grades

      # Collections.
      has_many :lobject_collections, dependent: :destroy
      has_many :lobject_parents, class_name: 'LobjectChild', foreign_key: 'child_id'
      has_many :lobject_children, class_name: 'LobjectChild', foreign_key: 'parent_id'

      # Related lobjects.
      has_many :lobject_related_lobjects, dependent: :destroy
      has_many :related_lobjects, through: :lobject_related_lobjects

      # Slugs
      has_many :lobject_slugs, dependent: :destroy

      # Organizations.
      belongs_to :organization

      accepts_nested_attributes_for :lobject_descriptions
      accepts_nested_attributes_for :lobject_downloads, allow_destroy: true
      accepts_nested_attributes_for :lobject_languages
      accepts_nested_attributes_for :lobject_titles
      accepts_nested_attributes_for :lobject_urls

      class << self
        def by_title(title)
          joins(:lobject_titles).where('lobject_titles.title' => title)
        end

        def bulk_edit(sample, lobjects)
          before = init_for_bulk_edit(lobjects)
          after  = sample

          transaction do
            lobjects.each do |lobject|
              # Alignments
              lobject.lobject_alignments.where(alignment_id: before.alignment_ids).where.not(alignment_id: after.alignment_ids).destroy_all
              (after.alignment_ids - before.alignment_ids).each do |alignment_id|
                lobject.lobject_alignments.find_or_create_by!(alignment_id: alignment_id)
              end

              # Grades
              lobject.lobject_grades.where(grade_id: before.grade_ids).where.not(grade_id: after.grade_ids).destroy_all
              (after.grade_ids - before.grade_ids).each do |grade_id|
                lobject.lobject_grades.find_or_create_by!(grade_id: grade_id)
              end

              # Resource types
              lobject.lobject_resource_types.where(resource_type_id: before.resource_type_ids).where.not(resource_type_id: after.resource_type_ids).destroy_all
              (after.resource_type_ids - before.resource_type_ids).each do |resource_type_id|
                lobject.lobject_resource_types.find_or_create_by!(resource_type_id: resource_type_id)
              end

              # Subjects
              lobject.lobject_subjects.where(subject_id: before.subject_ids).where.not(subject_id: after.subject_ids).destroy_all
              (after.subject_ids - before.subject_ids).each do |subject_id|
                lobject.lobject_subjects.find_or_create_by!(subject_id: subject_id)
              end
            end
          end
        end

        def init_for_bulk_edit(lobjects)
          lobject = new
          lobject.alignment_ids     = lobjects.map(&:alignment_ids).inject { |memo, ids| memo &= ids }
          lobject.grade_ids         = lobjects.map(&:grade_ids).inject { |memo, ids| memo &= ids }
          lobject.resource_type_ids = lobjects.map(&:resource_type_ids).inject { |memo, ids| memo &= ids }
          lobject.subject_ids       = lobjects.map(&:subject_ids).inject { |memo, ids| memo &= ids }
          lobject
        end

        def search(*args)
          __elasticsearch__.search(*args)
        end

        def with_lr_source
          joins(lobject_documents: { document: :source_document })
          .where('source_documents.source_type' => SourceDocument.source_types[:lr])
        end

        def find_root_lobject_for_curriculum(subject)
          subject = subject.to_sym

          raise 'Subject must be ELA or Math' unless [:ela, :math].include?(subject)

          if subject == :ela
            title = LobjectTitle.find_by(title: 'ELA Curriculum Map')
          elsif subject == :math
            title = LobjectTitle.find_by(title: 'Math Curriculum Map')
          end
          title.lobject
        end

        def find_curriculum_lobjects(subject)
          find_root_lobject_for_curriculum(subject)
          .lobject_collections.first.lobject_children.map { |c| c.child }
        end

        def find_curriculums
          {
            ela: find_curriculum_lobjects(:ela),
            math: find_curriculum_lobjects(:math)
          }
        end
      end

      def title
        lobject_titles.first.try(:title)
      end

      def description
        lobject_descriptions.first.try(:description)
      end

      def doc_created_at
        documents.order(doc_created_at: :asc).limit(1).first.try(:doc_created_at)
      end

      def has_inactive_doc?
        documents.any? { |doc| !doc.active }
      end

      def url
        self.urls.first
      end

      def language
        lobject_languages.first.try(:language)
      end

      def find_collections
        children_table = LobjectChild.arel_table

        collection_ids = LobjectChild
          .select(:lobject_collection_id)
          .where(
            children_table[:parent_id].eq(id)
            .or(children_table[:child_id].eq(id))
          )
          .uniq
          .pluck(:lobject_collection_id)

        LobjectCollection.includes(:lobject).where(id: collection_ids, lobjects: { hidden: false })
      end

      def collection_trees
        @collection_trees ||= find_collections.map { |c| c.tree }
      end

      def shallow_trees
        @shallow_trees ||= collection_trees.map do |tree|
          node = tree.find { |n| n.content.id == id }
          (node.parentage || []).reverse + [node]
        end
      end

      def unbounded_curriculum
        if curriculum_map_collection
          @unbounded_curriculum ||= UnboundedCurriculum.new(curriculum_map_collection, self)
        end
      end

      def related_lobjects
        @related_lobjects ||= lobject_related_lobjects
          .includes(related_lobject: [:lobject_titles])
          .order(:position)
          .map(&:related_lobject)
      end

      def reload(options = nil)
        super
        @collection_trees = nil
        @shallow_trees = nil
        @related_lobjects = nil
        self
      end

      def lobject_child_for_collection(collection)
        LobjectChild.find_by(child: self, collection: collection)
      end

      def curriculum_map_collection
        find_collections.where(lobject_collection_type: LobjectCollectionType.curriculum_map).first
      end

      def curriculum_root
        curriculum_map_collection && curriculum_map_collection.lobject.lobject_parents.first.parent
      end

      def curriculum_subject
        if curriculum_root
          t = curriculum_root.title
          if t.include?('Math')
            :math
          elsif t.include?('ELA')
            :ela
          end
        end
      end

      def slug_for_collection(collection)
        lobject_slugs.find_by(lobject_collection_id: collection.id).try(:value)
      end

      def slug
        lobject_slugs.first.try(:value)
      end

      # ElasticSearch.
      include Searchable
      include Searchable::Callbacks

      settings analysis: {
          filter: {
            lobjects_synonyms_filter: {
              type: 'synonym',
              synonyms: ['']
            }
          },
          analyzer: {
            lobjects_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: [ 'standard', 'lowercase', 'stop', 'lobjects_synonyms_filter' ],
              stopwords: %w(an and are as at be but by for if in into is it
                            no not of on or such that the their then there these
                            they this to was will with)
            }
          }
        } do

        mapping do

          # Relationships are stored as nested so we can search on multiple fields
          # per child item (e.g. alignments.name AND alignments.framework_url).
          #
          # Multi-fields have duplicate not_analyzed storage for precision searching.
          #
          # 'full' fields collect values from multiple fields. 
          # (Doing that manually allows for more flexibility than copy_to.)

          indexes :age_ranges, type: :nested do
            indexes :range, type: :string, index: :not_analyzed
          end

          indexes :alignments, type: :nested do
            indexes :full, type: 'multi_field' do
              indexes :full, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end

            indexes :name, type: 'multi_field' do
              indexes :name, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end

            indexes :framework, type: 'multi_field' do
              indexes :framework, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end

            indexes :framework_url, type: 'multi_field' do
              indexes :framework_url, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :collections, type: :nested do
          end

          indexes :curriculum_title, type: :string, search_analyzer: :lobjects_analyzer

          indexes :description, type: :string, search_analyzer: :lobjects_analyzer

          indexes :downloads, type: :nested do
            indexes :filename, index: :not_analyzed
            indexes :filesize, index: :not_analyzed
            indexes :url, index: :not_analyzed

            indexes :content_type, type: 'multi_field' do
              indexes :content_type, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :grades, type: :nested do
            indexes :grade, type: 'multi_field' do
              indexes :grade, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :identities, type: :nested do
            indexes :full, type: 'multi_field' do
              indexes :full, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end

            indexes :name, type: 'multi_field' do
              indexes :name, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end

            indexes :identity_type, type: 'multi_field' do
              indexes :identity_type, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :languages, type: :nested do
            indexes :name, type: 'multi_field' do
              indexes :name, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :resource_locators, type: :nested do
            indexes :url, type: 'multi_field' do
              indexes :url, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :resource_types, type: :nested do
            indexes :name, type: 'multi_field' do
              indexes :name, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :sources, type: :nested do
            indexes :engageny, type: :nested
          end

          indexes :subjects, type: :nested do
            indexes :name, type: 'multi_field' do
              indexes :name, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :topics, type: :nested do
            indexes :name, type: 'multi_field' do
              indexes :name, type: :string
              indexes :raw, type: :string, index: :not_analyzed
            end
          end

          indexes :title, type: 'multi_field' do
            indexes :title, type: :string, search_analyzer: :lobjects_analyzer
            indexes :raw, type: :string, index: :not_analyzed
          end
        end
      end

      def as_indexed_json(options={})
        LobjectSerializer.new(self).as_indexed_json(options)
      end
    end
  end
end
