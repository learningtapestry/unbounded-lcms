module DocTemplate
  class BaseMetadata
    include Virtus.model

    attribute :grade, String
    attribute :subject, String
    attribute :teaser, String
    attribute :title, String
    attribute :unit, String

    attribute :description, String
    attribute :materials, String
    attribute :preparation, String

    attribute :resource_subject, String, default: -> (m, _) { m.subject.try(:downcase) }
  end
end
