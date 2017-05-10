module DocTemplate
  module Objects
    class AgendaMetadata
      include Virtus.model

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

        attribute :id, String
        attribute :title, String
        attribute :metacognition, MetaCognition
        attribute :metadata, MetaData

        attribute :time, Integer, default: ->(s, _) { s.metadata.time }
        attribute :level, Integer, default: 2
      end

      class Group
        include Virtus.model

        attribute :id, String
        attribute :title, String
        attribute :metadata, MetaData
        attribute :children, Array[Section]

        attribute :time, Integer, default: ->(g, _) { g.metadata.time }
        attribute :level, Integer, default: 1
      end

      attribute :groups, Array[Group]

      def self.build_from(data)
        agenda_data =
          data.map do |d|
            d[:children].each do |s|
              s[:metadata]['time'] = s[:metadata]['time'].to_s[/\d+/].to_i || 0
            end
            d.deep_merge(metadata: { time: d[:children].sum { |s| s[:metadata]['time'] } })
          end
        new(groups: agenda_data)
      end

      def group_by_id(id)
        g = groups.find { |s| s.id == id }
        raise DocTemplateError, "Group #{id} not found at agenda" unless g.present?
        g
      end

      def section_by_id(id)
        groups.each do |g|
          section = g.children.find { |s| s.id == id }
          return section if section
        end
        raise DocTemplateError, "Section #{id} not found at agenda"
      end
    end
  end
end
