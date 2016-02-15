module ReactRenderable
  extend ActiveSupport::Concern

  included do
    class_attribute :react_view

    self.react_view = 'react/index'

    def react_render(props: {}, prerender: false)
      @props = props
      @props[:path] = request.path_info
      @prerender = prerender
      render self.class.react_view
    end
  end
end
