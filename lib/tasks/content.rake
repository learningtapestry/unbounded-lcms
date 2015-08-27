require 'content/tasks'

namespace :test do
  Rails::TestTask.new(content: 'test:prepare') do |t|
    t.pattern = 'lib/content/test/**/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ['test:content']
