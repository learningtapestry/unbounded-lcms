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

        attribute :metacognition, MetaCognition
        attribute :metadata, MetaData
        attribute :title, String

        # aliases to build toc
        attribute :active, Boolean, default: false
        attribute :anchor, String, default: ->(s, _) { "#{s.idx} #{s.title}".parameterize }
        attribute :idx, Integer
        attribute :level, Integer, default: 2
        attribute :time, Integer, default: ->(s, _) { s.metadata.time }
        attribute :use_color, Boolean, default: false
      end

      class Group
        include Virtus.model

        attribute :children, Array[Section]
        attribute :metadata, MetaData
        attribute :title, String

        # aliases to build toc
        attribute :active, Boolean, default: false
        attribute :anchor, String, default: ->(g, _) { "#{g.idx} #{g.title}".parameterize }
        attribute :idx, Integer
        attribute :level, Integer, default: 1
        attribute :time, Integer, default: ->(g, _) { g.metadata.time }
      end

      attribute :children, Array[Group]

      def self.build_from(data)
        agenda_data =
          data.map do |d|
            d[:children].each do |s|
              s[:metadata]['time'] = s[:metadata]['time'].to_s[/\d+/].to_i || 0
              use_color = s[:metadata]['color']
              s[:use_color] = use_color.present? ? use_color.casecmp('yes').zero? : false
            end
            d.deep_merge(metadata: { time: d[:children].sum { |s| s[:metadata]['time'] } })
          end
        new(set_index(children: agenda_data))
      end

      def add_break
        idx = children.index { |c| !c.active } || -1
        children.insert(idx, Group.new(title: 'optbreak', anchor: 'optbreak', time: 0, children: []))
      end
    end
  end
end
