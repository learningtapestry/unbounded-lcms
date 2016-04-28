module Search
  class Document
    include Virtus.model

    attribute :id, String
    attribute :model_type, String
    attribute :model_id, Integer
    attribute :title, String
    attribute :teaser, String
    attribute :description, String
    attribute :misc, String

    def self.build_from(model)
      if model.is_a?(Resource)
        self.new **attrs_from_resource(model)

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

    def self.search(term, options={})
      repository.search repository.build_query(term, options)
    end

    def self.all(options={})
      limit = options.fetch(:limit, 10)
      page = options.fetch(:page, 1)

      repository.search({ query: { match_all: {} }, size: limit, from: page })
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

      def self.attrs_from_resource(model)
        {
          id: "resource_#{model.id}",
          model_type: :resource,
          model_id: model.id,
          title: model.title,
          teaser: model.teaser,
          description: model.description,
          misc: [model.short_title, model.subtitle, model.teaser].compact,
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
          misc: [model.name, model.teaser, model.content].compact,
        }
      end
  end
end
