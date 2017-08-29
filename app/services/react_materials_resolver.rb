# frozen_string_literal: true

class ReactMaterialsResolver
  class << self
    def resolve(html, document)
      content = Nokogiri::HTML.fragment(html)
      content.css("[data-react-class='MaterialsContainer']").each do |node|
        replace_react(node, document)
      end
      content.to_html
    end

    private

    def replace_react(node, document)
      node.remove && return if (data = node.attr('data-react-props')).blank?
      raw_props = JSON.parse(data)
      node.remove && return if (raw_props['material_ids']).empty?

      props = PreviewsMaterialSerializer.new(raw_props, document)
      # TODO: find out what is wrong with server rendering here for web version
      component = h.react_component('MaterialsContainer', props, prerender: document.pdf_type != 'none')
      node.replace(component)
    end

    def h
      ActionController::Base.helpers
    end
  end
end
