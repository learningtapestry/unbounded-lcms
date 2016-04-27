module Search
  class Document
    include Virtus.model

    attribute :doc_type
    attribute :title, String
    attribute :description, String
    attribute :misc, String

    def self.repository
      @@repository ||= ::Search::Repository.new
    end

    def repository
      self.class.repository
    end

    def self.build_from(model)
      if model.is_a?(Resource)
        self.new **attrs_from_resource(model)

      elsif model.is_a?(ContentGuide)
        self.new **attrs_from_content_guide(model)

      else
        raise "Unsupported Type for Search : #{model.class.name}"
      end
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
          doc_type: :resource,
          title: model.title,
          description: model.description,
          misc: [model.short_title, model.subtitle, model.teaser].compact,
        }
      end

      def self.attrs_from_content_guide(model)
        {
          doc_type: :content_guide,
          title: model.title,
          description: model.description,
          misc: [model.name, model.teaser, model.content].compact,
        }
      end
  end
end
