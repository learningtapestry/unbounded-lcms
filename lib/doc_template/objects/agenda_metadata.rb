# frozen_string_literal: true

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

        attribute :standard, String, default: ''
        attribute :time, Integer, default: 0
      end

      class Section
        include Virtus.model

        attribute :materials, String
        attribute :metacognition, MetaCognition
        attribute :metadata, MetaData
        attribute :title, String

        # aliases to build toc
        attribute :anchor, String, default: ->(s, _) { "#{s.idx}-#{s.title}".parameterize }
        attribute :deselectable, Boolean, default: true
        attribute :icon, String
        attribute :idx, Integer
        attribute :level, Integer, default: 2
        attribute :priority, Integer, default: 0
        attribute :standard, String, default: ->(s, _) { s.metadata.standard }
        attribute :time, Integer, default: ->(s, _) { s.metadata.time }
        attribute :use_color, Boolean, default: false

        attribute :material_ids, Array[Integer], default: []
      end

      class Group
        include Virtus.model

        attribute :children, Array[Section]
        attribute :metadata, MetaData
        attribute :title, String

        # aliases to build toc
        attribute :anchor, String, default: ->(g, _) { "#{g.idx}-#{g.title}".parameterize }
        attribute :handled, Boolean, default: false
        attribute :idx, Integer
        attribute :level, Integer, default: 1
        attribute :time, Integer, default: ->(g, _) { g.metadata.time }
      end

      attribute :children, Array[Group]

      def self.build_from(data)
        copy = Marshal.load Marshal.dump(data)
        agenda_data =
          copy.map do |d|
            d[:children].each do |s|
              m = s[:metadata]
              s[:icon] = m['icon']
              s[:material_ids] = m['material_ids']
              s[:priority] = m['priority']
              m['time'] = m['time'].to_s[/\d+/].to_i || 0
              s[:use_color] = m['color'].present? ? m['color'].casecmp('yes').zero? : false
              s[:deselectable] = m['deselectable'].present? ? m['deselectable'].casecmp('yes').zero? : true
            end
            d.deep_merge(metadata: { time: d[:children].sum { |s| s[:metadata]['time'] } })
          end
        new(set_index(children: agenda_data))
      end

      def add_break
        idx = children.index { |c| !c.handled } || -1
        group = Group.new title: '45 Minute Mark', anchor: 'optbreak', time: 0, children: []
        children.insert(idx, group)
      end
    end
  end
end
