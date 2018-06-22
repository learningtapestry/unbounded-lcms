# frozen_string_literal: true

namespace :resources do
  desc 'Fix curriculum metadata'
  task fix_metadata: [:environment] { ResourceTasks.fix_metadata }

  desc 'Generate Unit Document Bundles'
  task generate_bundles: [:environment] { ResourceTasks.generate_unit_bundles }

  desc 'Generate hierarchical positions for resources'
  task generate_positions: [:environment] { GenerateHierarchicalPositions.new.generate! }

  desc 'Generate slugs'
  task generate_slugs: [:environment] { Slug.generate_resources_slugs }

  desc 'Updates time to teach resources'
  task update_time_to_teach: [:environment] { ResourceTasks.update_time_to_teach }

  desc 'Sync reading assignment'
  task sync_reading_assignments: [:environment] { ResourceTasks.sync_reading_assignments }

  desc 'Import V1 json files'
  task :json_import, %i(slug) => :environment do |_t, args|
    raise "Slug param required, e.g: json_import['math/grade 6']" unless args[:slug]
    ResourcesJsonImporter.new(args[:slug]).run
  end

  desc 'Clear detached/orphan resources'
  task clear_detached: :environment do
    rtype = Resource.resource_types[:resource]
    detached = Resource.where(tree: false, resource_type: rtype)
    puts "===> Removing #{detached.count} detached resources"
    detached.destroy_all
  end
end
