module DocTemplate
  module Objects
    class TOCMetadata
      include Virtus.model

      class Heading
        include Virtus.model

        attribute :anchor, String
        attribute :time, Integer
        attribute :title, String
        attribute :level, Integer
        attribute :children, Array[Heading], default: []
      end

      attribute :children, Array[Heading]
      attribute :total_time, Integer, default: -> (t, _) { t.children.sum(&:time) }

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
end
