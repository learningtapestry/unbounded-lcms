namespace :db do

  # db:dump
  desc 'Dumps the database.'
  task dump: :environment do
    config = ActiveRecord::Base.connection_config

    dump_cmd = <<-bash
      PGPASSWORD=#{config[:password]} \
      pg_dump \
        --host #{config[:host]} \
        --username #{config[:username]} \
        --clean \
        --no-owner \
        --no-acl \
        --format=c \
        -n public \
        #{config[:database]} > #{Rails.root}/db/dump/content.dump
    bash

    puts "Dumping #{Rails.env} database."

    raise unless system(dump_cmd)
  end

  # db:restore
  desc 'Restores the database.'
  task restore: [:environment, :drop, :create] do
    config = ActiveRecord::Base.connection_config

    restore_cmd = <<-bash
      PGPASSWORD=#{config[:password]} \
      pg_restore \
        --host #{config[:host]} \
        --username #{config[:username]} \
        --no-owner \
        --no-acl \
        -n public \
        --dbname #{config[:database]} #{Rails.root}/db/dump/content.dump
    bash

    puts "Restoring #{Rails.env} database."

    raise unless system(restore_cmd)
  end
end
