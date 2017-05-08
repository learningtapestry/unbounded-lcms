module DocTemplate
  class TOCMetadata
    include Virtus.model

    class Heading
      include Virtus.model

      attribute :id, String
      attribute :time, Integer
      attribute :title, String
      attribute :level, Integer
      attribute :children, Array[Heading], default: []
    end

    attribute :groups, Array[Heading]

    class << self
      def dump(data)
        data.to_json
      end

      def load(data)
        new(data)
      end
    end
  end
end
