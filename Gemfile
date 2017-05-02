source 'https://rubygems.org'

gem 'rails', '4.2.4'

# session storage
gem 'activerecord-session_store', '~> 1.0'

# graphs
gem 'axlsx', '~> 2.1.0.pre'
gem 'edge', '~> 0.4.2', require: 'edge'

# file uploading
gem 'carrierwave', '~> 0.10.0'

# system
gem 'daemons', '~> 1.2', '>= 1.2.3'
gem 'dotenv-rails', '~> 2.0.2', groups: [:development, :integration, :test]
gem 'foreman', '~> 0.78.0'
gem 'ruby-progressbar', '~> 1.7', '>= 1.7.5'

# authentication
gem 'devise', '~> 3.5.2', require: ['devise', 'devise/orm/active_record']

# search with elastic search
gem 'elasticsearch-dsl', '~> 0.1.1'
gem 'elasticsearch-model', '~> 0.1.7'
gem 'elasticsearch-persistence', '~> 0.1.7'
gem 'elasticsearch-rails', '~> 0.1.7'

# cloud interaction
gem 'fog', '~> 1.38'
gem 'aws-sdk-rails', '~> 1.0'

# google drive and documents (import/export)
gem 'google-api-client', '~> 0.9'
gem 'googleauth', '~> 0.4'

# json parsing
gem 'oj', '~> 2.12.12'
gem 'oj_mimic_json', '~> 1.0.1'

# database
gem 'pg', '~> 0.18.2'
gem 'postgres_ext', '~> 3.0'
# db search
gem 'ransack', '~> 1.7.0'
# data seeding
gem 'seedbank', '~> 0.3'
gem 'migration_data', '~> 0.2.1'
# tree data structure
gem 'rubytree', '~> 0.9.6'
gem 'closure_tree', '~> 6.0'
# ordering
gem 'order_as_specified', '~> 0.1.0'
# tags
gem 'acts-as-taggable-on', '~> 3.5'

# assets
gem 'react-rails', '~> 1.6'
gem 'sass-rails', '~> 5.0'
gem 'font-awesome-sass', '~> 4.4.0'
# TODO: foundation or bootstrap??
gem 'bootstrap-sass', '~> 3.3.5.1'
gem 'foundation-rails', '~> 6.2.1'
gem 'i18n-js', '~> 2.1.2'
gem 'jquery-rails'
gem 'js-routes', '~> 1.1.2'
gem 'turbolinks'
gem 'uglifier', '~> 3.0', '>= 3.0.4'
gem 'autoprefixer-rails', '~> 6.3.6'
# wysiwyg editor
gem 'ckeditor'

# serialization
gem 'jbuilder', '~> 2.0'
gem 'active_model_serializers', '~> 0.9.3'

# api clients
# TODO: remove one!
gem 'rest-client', '~> 1.8'
gem 'httparty', '~> 0.14.0'

# spreadsheet
gem 'roo', '~> 2.2'

# documentation
gem 'sdoc', '~> 0.4.0', group: :doc

# google analytics
gem 'staccato', '~> 0.4.7'

# pdf
gem 'wicked_pdf', '~> 1.0'
gem 'pdfjs_viewer-rails', '~> 0.0.9'

# pagination
gem 'will_paginate', '~> 3.0.7', require: ['will_paginate', 'will_paginate/active_record']
gem 'will_paginate-bootstrap'

# views
# truncate text in html tags
gem 'truncate_html', '~> 0.9.3'
gem 'validate_url', '~> 1.0'
# remove tags and styles not in whitelist
gem 'sanitize', '~> 4.2'

# redis
gem 'hiredis'
gem 'readthis'

# form/form models
gem 'nested_form'
gem 'simple_form'
gem 'virtus', '~> 1.0.5'

# fix thor version (command line)
gem 'thor', '0.19.1'

# HTML/XML parsing
gem 'nokogiri', '~> 1.6.0'
gem 'nikkou', '~> 0.0.5'

group :development, :test do
  gem 'pry-byebug'
  gem 'faker'
end

group :development do
  gem 'rack-livereload', '~> 0.3.16'
  gem 'guard-livereload', '~> 2.5', '>= 2.5.2'
  gem 'safe_attributes', '~> 1.0.10'
  gem 'spring'
  gem 'web-console', '~> 2.0'
  gem 'rack-mini-profiler', '~> 0.9.9.2', require: false
  gem 'quiet_assets', '~> 1.1'
  gem 'puma', '~> 3.4'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '~> 1.4'
  gem 'email_spec', '~> 2.1'
  gem 'guard'
  gem 'guard-minitest'
  gem 'minitest-focus'
  gem 'minitest-rails-capybara'
  gem 'minitest-vcr'
  gem 'poltergeist'
  gem 'shoulda', require: false
  gem 'webmock', '~> 3.0'
  gem 'simplecov', require: false
end

source 'https://rails-assets.org' do
  gem 'rails-assets-es6-promise', '~> 3.1.2'
  gem 'rails-assets-eventemitter3', '~> 1.2.0'
  gem 'rails-assets-fetch', '~> 0.11.0'
  gem 'rails-assets-lodash', '~> 3.9.3'
  gem 'rails-assets-knockout', '~> 3.3.0'
  gem 'rails-assets-classnames', '~> 2.2.3'
  gem 'rails-assets-selectize', '~> 0.12.1'
end
