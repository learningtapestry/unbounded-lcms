# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production? || Rails.env.production_swap?

require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/lib/doc_template/tags/shared_examples/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

# Enable rake db:seed tasks to be invoked when needed
require 'rake'
Rails.application.load_tasks

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.include FeatureHelper, type: :feature
  config.include ResourceFactoryHelper

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end
