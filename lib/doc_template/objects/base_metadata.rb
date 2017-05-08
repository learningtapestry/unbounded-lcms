module DocTemplate
  class BaseMetadata
    include Virtus.model

    attribute :subject, String
    attribute :grade, String
    attribute :title, String
    attribute :teaser, String

    attribute :description, String
    attribute :materials, String
    attribute :preparation, String
  end
end
