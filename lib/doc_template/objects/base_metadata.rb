module DocTemplate
  module Objects
    class BaseMetadata
      include Virtus.model

      attribute :cc_attribution, String, default: ''
      attribute :description, String
      attribute :grade, String
      attribute :lesson, String
      attribute :lesson_mathematical_practice, String, default: ''
      attribute :lesson_objective, String
      attribute :lesson_standard, String
      attribute :materials, String
      attribute :module, String
      attribute :preparation, String
      attribute :resource_subject, String, default: ->(m, _) { m.subject.try(:downcase) }
      attribute :standard, String
      attribute :subject, String
      attribute :teaser, String
      attribute :title, String
      attribute :topic, String
      attribute :unit, String

      def self.build_from(data)
        new(data.transform_keys { |k| k.to_s.underscore })
      end
    end
  end
end
