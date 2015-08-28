require 'content/tasks'

namespace :test do
  Rails::TestTask.new(content: 'test:prepare') do |t|
    t.pattern = 'lib/content/test/**/*_test.rb'
  end
end

namespace :db do
  task dump: :environment do
    cfg = ActiveRecord::Base.connection_config
    dump_cmd = "pg_dump --host #{cfg[:host]} --username #{cfg[:username]} --clean --no-owner --no-acl --format=c -n public #{cfg[:database]} > #{Rails.root}/db/content.dump"
    puts "Dumping #{Rails.env} database."
    raise unless system("PGPASSWORD=#{cfg[:password]} #{dump_cmd}")
  end

  task restore: :environment do
    cfg = ActiveRecord::Base.connection_config
    restore_cmd = "pg_restore --host #{cfg[:host]} --username #{cfg[:username]} --clean --if-exists --no-owner --no-acl -n public --dbname #{cfg[:database]} #{Rails.root}/db/content.dump"
    puts "Restoring #{Rails.env} database."
    raise unless system("PGPASSWORD=#{cfg[:password]} #{restore_cmd}")
  end

  namespace :test do
    desc 'Prepares the integration testing database'
    task prepare_integration: [:environment, :load_config] do
      raise unless system('RAILS_ENV=development rake db:dump')

      puts 'Creating integration database.'
      raise unless system('RAILS_ENV=integration rake db:drop db:create')

      raise unless system('RAILS_ENV=integration rake db:restore')
    end
  end
end

Rake::Task['test:run'].enhance ['test:content']
