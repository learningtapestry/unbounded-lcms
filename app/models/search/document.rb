module Search
  class Document < ElasticSearchDocument
    include Virtus.model
    include GradeListHelper

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

    def grade_list
      grade
    end

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

    # Overrides ElasticSearchDocument.search to include standards search
    def self.search(term, options={})
      return repository.empty_response unless repository.index_exists?
      return repository.search(repository.all_query(options)) unless term.present?

      repository.multisearch(
        [
          repository.standards_query(term, options),
          repository.tags_query(term, [:tag_keywords], options),
          repository.tags_query(term, [:tag_authors, :tag_texts], options),
          repository.fts_query(term, options)
        ]
      ).max_by(&:total)
    end

    private

      def self.attrs_from_resource(model, curriculum=nil)
        curriculum ||= model.curriculums.last
        if model.resource_type == 'resource'
          doc_type = curriculum.curriculum_type.name
        else
          doc_type = model.resource_type
        end

        id = curriculum ? "curriculum_#{curriculum.id}" : "resource_#{model.id}"

        pos = if model.media? || model.generic?
                grade_position(model)
              else
                curriculum.try(:hierarchical_position)
              end

        tags = model.named_tags
        {
          id: id,
          model_type: :resource,
          model_id: model.id,
          title: model.title,
          teaser: model.teaser,
          description: model.description,
          doc_type: doc_type,
          subject: model.subject,
          grade: model.grade_list,
          breadcrumbs: curriculum.try(:breadcrumb_title),
          slug: curriculum.try(:slugs).try(:first).try(:value),
          tag_authors: tags[:authors],
          tag_texts: tags[:texts],
          tag_keywords: tags[:keywords],
          tag_standards: tags[:ccss_standards],
          position: pos,
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
          grade: model.grade_list,
          breadcrumbs: nil,
          permalink: model.permalink,
          slug: model.slug,
          tag_authors: [],
          tag_texts: [],
          tag_keywords: [],
          tag_standards: [],
          position: grade_position(model),
        }
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
          rtype = model.try(:[], :resource_type) || 0
          # for generic resource use the min grade, instead the avg
          grade_pos = model.grade_list.map {|g| GradeListHelper::GRADES.index(g) }.compact.min || 0
          last_pos = model.grade_list.size
        else
          rtype = 0
          grade_pos = model.grade_avg_num
          last_pos = 0
        end
        first_pos = 90 + rtype

        [first_pos, grade_pos, 0, 0, last_pos].map { |n| n.to_s.rjust(2, '0') }.join(' ')
      end
  end
end
