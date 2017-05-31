module Search
  class Document < ElasticSearchDocument
    include Virtus.model

    attribute :id, String
    attribute :model_type, String
    attribute :model_id, Integer
    attribute :title, String
    attribute :teaser, String
    attribute :description, String
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
    attribute :position, String

    def self.build_from(model)
      if model.is_a?(Resource)
        new(**attrs_from_resource(model))

      elsif model.is_a?(ContentGuide)
        new(**attrs_from_content_guide(model))

      else
        raise "Unsupported Type for Search : #{model.class.name}"
      end
    end

    # Overrides ElasticSearchDocument.search to include standards search
    def self.search(term, options = {})
      return repository.empty_response unless repository.index_exists?

      if term.present?
        query = repository.standards_query(term, options)
        res = repository.search query
        return res if res.count > 0

        query = repository.fts_query(term, options)
      else
        query = repository.all_query(options)
      end
      repository.search query
    end

    def self.attrs_from_resource(model)
      tags = model.named_tags

      {
        id: "resource_#{model.id}",
        model_type: 'resource',
        model_id: model.id,
        title: model.title,
        teaser: model.teaser,
        description: model.description,
        doc_type: doc_type(model),
        subject: model.subject,
        grade: model.grades.list,
        breadcrumbs: Breadcrumbs.new(model).title,
        slug: model.slug,
        tag_authors: tags[:authors] || [],
        tag_texts: tags[:texts] || [],
        tag_keywords: tags[:keywords] || [],
        tag_standards: tags[:ccss_standards] || [],
        position: resource_position(model)
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
        doc_type: 'content_guide',
        subject: model.subject,
        grade: model.grades.list,
        breadcrumbs: nil,
        permalink: model.permalink,
        slug: model.slug,
        tag_authors: [],
        tag_texts: [],
        tag_keywords: [],
        tag_standards: [],
        position: grade_position(model)
      }
    end

    def self.resource_position(model)
      if model.media? || model.generic?
        grade_position(model)
      else
        model.hierarchical_position
      end
    end

    def self.doc_type(model)
      model.resource_type == 'resource' ? model.curriculum_type : model.resource_type
    end

    # Position mask:
    # - Since lessons uses 4 blocks of 2 numbers for (grade, mod, unit, lesson),
    #   we use 5 blocks to place them after lessons.
    # - the first position is realted to the resource type (always starting
    #   with 9 to be placed after the lessons).
    # - The second most significant is related to the grade
    # - The last position is the number of different grades covered, i.e:
    #   a resource with 3 different grades show after one with 2, (more specific
    #   at the top, more generic at the bottom)
    def self.grade_position(model)
      if model.is_a?(Resource) && model.generic?
        rtype = model[:resource_type] || 0
        # for generic resource use the min grade, instead the avg
        grade_pos = model.grades.list.map { |g| Grades::GRADES.index(g) }.compact.min || 0
        last_pos = model.grades.list.size
      else
        rtype = 0
        grade_pos = model.grades.average_number
        last_pos = 0
      end
      first_pos = 90 + rtype

      [first_pos, grade_pos, 0, 0, last_pos].map { |n| n.to_s.rjust(2, '0') }.join(' ')
    end

    def grades
      @grades ||= Grades.new(self)
    end
  end
end
