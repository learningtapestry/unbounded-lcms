# frozen_string_literal: true

module DocTemplate
  module Tags
    module Helpers
      include ActionView::Helpers::TagHelper

      def materials_container(props)
        return if props.nil?

        content_tag :div, nil, data: { react_class: 'MaterialsContainer', react_props: props }
      end
    end
  end
end
