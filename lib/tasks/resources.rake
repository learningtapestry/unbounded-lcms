# frozen_string_literal: true

namespace :resources do
  desc 'Import V1 json files'
  task :json_import, %i(slug) => :environment do |_t, args|
    raise "Slug param required, e.g: json_import['math/grade 6']" unless args[:slug]
    ResourcesJsonImporter.new(args[:slug]).run
  end
end
