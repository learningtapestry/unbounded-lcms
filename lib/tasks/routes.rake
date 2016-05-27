namespace :routes do

  desc 'Generate routes.js'
  task generate_js: [:environment] do
    JsRoutes.generate!("app/assets/javascripts/generated/routes.js")
  end

end
