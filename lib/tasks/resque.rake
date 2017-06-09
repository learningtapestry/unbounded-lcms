require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    ENV['QUEUE'] ||= 'default'
  end
end
