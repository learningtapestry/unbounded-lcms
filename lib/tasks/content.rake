require 'content/tasks'

namespace :test do
  Rails::TestTask.new(content: 'test:prepare') do |t|
    t.pattern = 'lib/content/test/**/*_test.rb'
  end
end

namespace :db do
  desc 'Dumps the database.'
  task dump: :environment do
    cfg = ActiveRecord::Base.connection_config
    dump_cmd = "pg_dump --host #{cfg[:host]} --username #{cfg[:username]} --clean --no-owner --no-acl --format=c -n public #{cfg[:database]} > #{Rails.root}/db/content.dump"
    puts "Dumping #{Rails.env} database."
    raise unless system("PGPASSWORD=#{cfg[:password]} #{dump_cmd}")
  end

  desc 'Restores the database.'
  task restore: [:environment, :create, :migrate] do
    cfg = ActiveRecord::Base.connection_config
    restore_cmd = "pg_restore --host #{cfg[:host]} --username #{cfg[:username]} --clean --if-exists --no-owner --no-acl -n public --dbname #{cfg[:database]} #{Rails.root}/db/content.dump"
    puts "Restoring #{Rails.env} database."
    raise unless system("PGPASSWORD=#{cfg[:password]} #{restore_cmd}")
  end

  desc 'Restores the EngageNY database dump.'
  task restore_engageny: :environment do
    cfg = ActiveRecord::Base.configurations['engageny'].symbolize_keys
    conn = ActiveRecord::Base.connection

    puts 'Creating EngageNY database.'
    conn.execute("drop database #{cfg[:database]}")
    conn.execute("create database #{cfg[:database]}")

    puts 'Restoring EngageNY database.'
    raise unless system("PGPASSWORD=#{cfg[:password]} pg_restore --host #{cfg[:host]} --username #{cfg[:username]} --clean --if-exists --no-owner --no-acl -n public --dbname #{cfg[:database]} #{Rails.root}/db/engageny.dump")
  end

  namespace :test do
    desc 'Prepares the integration testing database'
    task prepare_integration: [:environment, :load_config] do
      raise unless system('RAILS_ENV=development rake db:dump')

      puts 'Creating integration database.'
      raise unless system('RAILS_ENV=integration rake db:drop db:restore')
    end
  end
end

namespace :content do
  desc 'Sets up the EngageNY database from scratch.'
  task setup_engageny: [:'db:restore_engageny', :'content:import_engageny']
end

Rake::Task['test:run'].enhance ['test:content']
