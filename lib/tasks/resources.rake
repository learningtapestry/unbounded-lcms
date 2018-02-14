# frozen_string_literal: true

namespace :resources do # rubocop:disable Metrics/BlockLength
  desc 'Fixes formatting for resources'
  task fix_formatting: [:environment] { ResourceTasks.fix_formatting }

  desc 'Fix lessons metadata'
  task fix_lessons_metadata: [:environment] { ResourceTasks.fix_lessons_metadata }

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
end
