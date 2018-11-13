# frozen_string_literal: true

module DocumentExporter
  Base.module_eval do
    def render_template(name, layout:)
      # Using backport of Rails 5 Renderer here
      ApplicationController.render(
        template: name,
        layout: layout,
        locals: { document: @document, options: @options }
      )
    end
  end
end