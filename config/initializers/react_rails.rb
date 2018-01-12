# frozen_string_literal: true

Rails.application.config.react.jsx_transform_options = {
  blacklist: %w(spec.functionName validation.react)
}

# Fixes server rendering in production.
# Ref. https://github.com/reactjs/react-rails/issues/443#issuecomment-180544359
Rails.application.config.react.server_renderer_options = {
  files: ['server_rendering.js'] # files to load for prerendering
}
