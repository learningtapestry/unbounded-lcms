require 'content/models/concerns/searchable'
require 'nokogiri'

module Content
  module Models
    class Lobject < ActiveRecord::Base

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

      # Related lobjects.
      has_many :lobject_related_lobjects, dependent: :destroy
      has_many :related_lobjects, through: :lobject_related_lobjects

      # Organizations.
      belongs_to :organization

      accepts_nested_attributes_for :lobject_descriptions
      accepts_nested_attributes_for :lobject_downloads, allow_destroy: true
      accepts_nested_attributes_for :lobject_languages
      accepts_nested_attributes_for :lobject_titles
      accepts_nested_attributes_for :lobject_urls

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

      # ElasticSearch.
      include Searchable
      include Searchable::Callbacks

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
          indexes :title, type: :string
          indexes :raw, type: :string, index: :not_analyzed
        end
      end

      def as_indexed_json(options={})
        LobjectSerializer.new(self).as_indexed_json(options)
      end
    end
  end
end
