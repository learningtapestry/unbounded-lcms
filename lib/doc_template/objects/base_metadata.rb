module DocTemplate
  module Objects
    class BaseMetadata
      include Virtus.model

      attribute :subject, String
      attribute :grade, String
      attribute :module, String
      attribute :unit, String
      attribute :lesson, String
      attribute :standard, String
      attribute :teaser, String
      attribute :title, String
      attribute :description, String
      attribute :materials, String
      attribute :preparation, String

      attribute :topic, String
      attribute :lesson_objective, String
      attribute :lesson_standard, String
      attribute :lesson_mathematical_practice, String, default: ''

      attribute :resource_subject, String, default: ->(m, _) { m.subject.try(:downcase) }

      def self.build_from(data)
        new(data.transform_keys { |k| k.to_s.underscore })
      end
    end
  end
end
