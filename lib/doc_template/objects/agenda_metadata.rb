module DocTemplate
  module Objects
    class AgendaMetadata
      include Virtus.model
      include DocTemplate::Objects::TocHelpers

      class MetaCognition
        include Virtus.model

        attribute :content, String
      end

      class MetaData
        include Virtus.model

        attribute :time, Integer, default: 0
      end

      class Section
        include Virtus.model

        attribute :title, String
        attribute :metacognition, MetaCognition
        attribute :metadata, MetaData

        attribute :time, Integer, default: ->(s, _) { s.metadata.time }
        attribute :anchor, String, default: ->(s, _) { "#{s.idx} #{s.title}".parameterize }
        attribute :level, Integer, default: 2
        attribute :idx, Integer
        attribute :active, Boolean, default: false
      end

      class Group
        include Virtus.model

        attribute :title, String
        attribute :metadata, MetaData
        attribute :children, Array[Section]

        attribute :time, Integer, default: ->(g, _) { g.metadata.time }
        attribute :anchor, String, default: ->(g, _) { "#{g.idx} #{g.title}".parameterize }
        attribute :level, Integer, default: 1
        attribute :idx, Integer
        attribute :active, Boolean, default: false
      end

      attribute :children, Array[Group]

      def self.build_from(data)
        agenda_data =
          data.map do |d|
            d[:children].each do |s|
              s[:metadata]['time'] = s[:metadata]['time'].to_s[/\d+/].to_i || 0
            end
            d.deep_merge(metadata: { time: d[:children].sum { |s| s[:metadata]['time'] } })
          end
        new(set_index(children: agenda_data))
      end
    end
  end
end
