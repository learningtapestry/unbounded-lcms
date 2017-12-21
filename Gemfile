# frozen_string_literal: true

ruby '2.3.3'

source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

# error handling
gem 'airbrake', '~> 6.2'

# session storage
gem 'activerecord-session_store', '~> 1.0'

# graphs
gem 'axlsx', '~> 2.1.0.pre'
gem 'edge', '~> 0.4.2', require: 'edge'

# file uploading
gem 'carrierwave', '~> 0.10.0'

# system
gem 'addressable', '~> 2.5.1'
gem 'daemons', '~> 1.2', '>= 1.2.3'
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1', groups: %i(development integration test)
gem 'foreman', '~> 0.78.0'
gem 'ruby-progressbar', '~> 1.7', '>= 1.7.5'

# authentication
gem 'devise', '~> 3.5.2', require: %w(devise devise/orm/active_record)

# search with elastic search
gem 'elasticsearch-dsl', '~> 0.1.5'
gem 'elasticsearch-model', '~> 5.0', '>= 5.0.1'
gem 'elasticsearch-persistence', '~> 5.0', '>= 5.0.1'
gem 'elasticsearch-rails', '~> 5.0', '>= 5.0.1'

# cloud interaction
gem 'aws-sdk-rails', '~> 1.0'
gem 'fog', '~> 1.38'

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
gem 'pg_search', '~> 2.1'
gem 'ransack', '~> 1.7.0'
# data seeding
gem 'migration_data', '~> 0.2.1'
gem 'seedbank', '~> 0.3'
# tree and list data structure
gem 'acts_as_list', '~> 0.9.10'
gem 'closure_tree', '~> 6.6'
gem 'rubytree', '~> 0.9.6'
# tags
gem 'acts-as-taggable-on', '~> 3.5'

# assets
gem 'autoprefixer-rails', '~> 6.4.0'
gem 'font-awesome-sass', '~> 4.4.0'
gem 'react-rails', '~> 1.6'
gem 'sass-rails', '~> 5.0'
# TODO: foundation or bootstrap??
gem 'bootstrap-sass', '~> 3.3.5.1'
gem 'foundation-rails', '~> 6.2.1'
gem 'i18n-js', '~> 3.0.2'
gem 'jquery-rails'
gem 'js-routes', '~> 1.1.2'
gem 'turbolinks'
gem 'uglifier', '~> 3.0', '>= 3.0.4'
# wysiwyg editor
gem 'ckeditor'

# serialization
gem 'active_model_serializers', '~> 0.9.3'
gem 'jbuilder', '~> 2.0'

# api clients
# TODO: remove one!
gem 'httparty', '~> 0.14.0'
gem 'rest-client', '~> 1.8'

# spreadsheet
gem 'roo', '~> 2.2'

# markup converters
gem 'pandoc-ruby', '~> 2.0.1'

# documentation
gem 'sdoc', '~> 0.4.0', group: :doc

# google analytics
gem 'staccato', '~> 0.4.7'

# job runner
gem 'activejob-retry', '~> 0.6.3'
gem 'resque', '~> 1.27', require: 'resque/server'
gem 'resque-scheduler', '~> 4.2'

# NOTE: Need to remove after upgrade to Rails 5
# backports
gem 'backport_new_renderer', '~> 1.0.0'

# pdf
gem 'combine_pdf', '~> 1.0.5'
gem 'pdfjs_viewer-rails', '~> 0.0.9'
gem 'wicked_pdf', '~> 1.0'

# thumbnails
gem 'mini_magick', '~> 4.8.0'

# pagination
gem 'will_paginate', '~> 3.0.7', require: %w(will_paginate will_paginate/active_record)
gem 'will_paginate-bootstrap'

# views
# truncate text in html tags
gem 'truncate_html', '~> 0.9.3'
gem 'validate_url', '~> 1.0'
# remove tags and styles not in whitelist
gem 'sanitize', '~> 4.2'
# shorten urls
gem 'bitly', '~> 1.0'

# user tracking
gem 'heap', '~> 1.0'

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
gem 'nikkou', '~> 0.0.5'
gem 'nokogiri', '~> 1.6.0'

# profiling
gem 'newrelic_rpm' # Used temporarily for debugging workers

group :development, :staging, :qa do
  gem 'mailcatcher', require: false
end

group :development, :test do
  gem 'brakeman', '~> 4.0.1', require: false
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'guard-livereload', '~> 2.5', '>= 2.5.2'
  gem 'pry-rails', '~> 0.3.5'
  gem 'puma', '~> 3.4'
  gem 'quiet_assets', '~> 1.1'
  gem 'rack-livereload', '~> 0.3.16'
  gem 'rack-mini-profiler', '~> 0.9.9.2', require: false
  gem 'safe_attributes', '~> 1.0.10'
  gem 'spring'
  gem 'web-console', '~> 2.0'
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
  # TODO: Remove after we get rid of MiniTest
  gem 'shoulda-context'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
  gem 'webmock', '~> 3.0'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-classnames', '~> 2.2.3'
  gem 'rails-assets-es6-promise', '~> 3.1.2'
  gem 'rails-assets-eventemitter3', '~> 1.2.0'
  gem 'rails-assets-fetch', '~> 0.11.0'
  gem 'rails-assets-jstree', '~> 3.3.4'
  gem 'rails-assets-knockout', '~> 3.3.0'
  gem 'rails-assets-lodash', '~> 3.9.3'
  gem 'rails-assets-selectize', '~> 0.12.1'
end
