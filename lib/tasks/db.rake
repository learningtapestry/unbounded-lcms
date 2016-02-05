namespace :db do

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

  desc 'Runs pg_restore.'
  task pg_restore: [:environment] do
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

  desc 'Drops, creates and restores the database from a dump.'
  task restore: [:environment, :drop, :create, :pg_restore]
end
