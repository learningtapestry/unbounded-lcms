# frozen_string_literal: true

module DocTemplate
  module Objects
    module TocHelpers
      extend ActiveSupport::Concern

      def level1_by_title(title)
        l1 = children.find { |c| !c.active && c.title.parameterize == title }
        raise DocumentError, "Level1 header #{title} not found at metadata" unless l1.present?
        l1.active = true
        l1
      end

      def level2_by_title(title)
        children.each do |c|
          l2 = c.children.find { |c1| !c1.active && c1.title.parameterize == title }
          if l2
            l2.active = true
            return l2
          end
        end
        raise DocumentError, "Level2 header #{title} not found at metadata"
      end

      def find_by_anchor(anchor)
        l1 = children.find { |c| c.anchor == anchor }
        raise DocumentError, "Anchor #{anchor} not found at metadata" if l1.blank?
        l1
      end

      class_methods do
        def set_index(data, params = { idx: 0 })
          return data if data['idx'].present?
          data['idx'] = params[:idx]
          params[:idx] += 1
          (data[:children] || []).each { |c| set_index(c, params) }
          data
        end
      end
    end
  end
end
