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
      props = PreviewsMaterialSerializer.new(node.attr('data-react-props')&.split(',')&.map(&:to_i) || [], document)
      # TODO: find out what is wrong with server rendering here for web version
      component = h.react_component('MaterialsContainer', props, prerender: document.pdf_type != 'none')
      node.replace(component)
    end

    def h
      ActionController::Base.helpers
    end
  end
end
