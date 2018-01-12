# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Adding wkhtmltopdf helpers
Rails.application.config.assets.configure do |env|
  env.context_class.class_eval do
    include WickedPdfHelper::Assets
  end
end

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  admin.css
  ckeditor/*
  gdoc.css
  main.css
  pdf.css
  pdf_js_preview.js
  pdf_plain.css
  server_rendering.js
  vendor/pdf.worker.js
)

Rails.application.config.assets.paths << "#{Rails.root}/public/javascripts"
