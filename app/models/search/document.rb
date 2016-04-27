module Search
  class Document
    include Virtus.model

    attribute :id, String
    attribute :model_type, String
    attribute :model_id, Integer
    attribute :title, String
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

    private

      def self.attrs_from_resource(model)
        {
          id: "resource_#{model.id}",
          model_type: :resource,
          model_id: model.id,
          title: model.title,
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
          description: model.description,
          misc: [model.name, model.teaser, model.content].compact,
        }
      end
  end
end
