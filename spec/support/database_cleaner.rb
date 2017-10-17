# frozen_string_literal: true

require 'database_cleaner'

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
