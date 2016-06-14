module Search
  class Document
    include Virtus.model

    attribute :id, String
    attribute :model_type, String
    attribute :model_id, Integer
    attribute :title, String
    attribute :teaser, String
    attribute :description, String
    # attribute :misc, String
    attribute :doc_type, String
    attribute :grade, String
    attribute :subject, String
    attribute :breadcrumbs, String
    attribute :permalink, String
    attribute :slug, String
    attribute :tag_authors, Array[String]
    attribute :tag_texts, Array[String]
    attribute :tag_keywords, Array[String]
    attribute :tag_standards, Array[String]

    def self.build_from(model)

      if model.is_a?(Resource)
        self.new **attrs_from_resource(model)

      elsif model.is_a?(Curriculum)
        self.new **attrs_from_resource(model.resource_item, model)

      elsif model.is_a?(ContentGuide)
        self.new **attrs_from_content_guide(model)

      else
        raise "Unsupported Type for Search : #{model.class.name}"
      end
    end

    def self.repository
      @repository ||= ::Search::Repository.new
    end

    def repository
      self.class.repository
    end

    def index!
      repository.save self
    end

    def delete!
      repository.delete self
    end

    def self.search(term, options={})
      return repository.empty_response unless repository.index_exists?

      if term.present?
        query = repository.build_query(term, options)

      else
        query = repository.build_query('', options)
        query[:query][:bool].delete(:should)
        query[:query][:bool][:must] = { match_all: {} }
      end

      repository.search query
    end

    # this is necessary for the ActiveModel::ArraySerializer#as_json method to work
    # (used on the concerns/pagination => #serialize_with_pagination)
    def read_attribute_for_serialization(key)
      if key == :id || key == 'id'
        attributes.fetch(key) { id }
      else
        attributes[key]
      end
    end

    private

      def self.attrs_from_resource(model, curriculum=nil)
        curriculum ||= model.curriculums.first
        if model.resource_type == 'resource'
          doc_type = curriculum.curriculum_type.name
        else
          doc_type = model.resource_type
        end

        id = curriculum ? "curriculum_#{curriculum.id}" : "resource_#{model.id}"

        tags = model.named_tags
        {
          id: id,
          model_type: :resource,
          model_id: model.id,
          title: model.title,
          teaser: model.teaser,
          description: model.description,
          # misc: [model.short_title, model.subtitle, model.teaser].compact,
          doc_type: doc_type,
          subject: model.subject,
          grade: model.grade_list,
          breadcrumbs: curriculum.try(:breadcrumb_title),
          slug: (curriculum.slugs.first.value rescue nil),
          tag_authors: tags[:authors],
          tag_texts: tags[:texts],
          tag_keywords: tags[:keywords],
          tag_standards: tags[:ccss_standards],
        }
      end

      def self.attrs_from_content_guide(model)
        {
          id: "content_guide_#{model.id}",
          model_type: :content_guide,
          model_id: model.id,
          title: model.title,
          teaser: model.teaser,
          description: model.description,
          # misc: [model.name, model.teaser, model.content].compact,
          doc_type: 'content_guide',
          subject: model.subject,
          grade: model.grade_list,
          breadcrumbs: nil,
          permalink: model.permalink,
          slug: model.slug,
          tag_authors: [],
          tag_texts: [],
          tag_keywords: [],
          tag_standards: [],

        }
      end
  end
end
