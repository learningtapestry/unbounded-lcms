namespace :curriculum do
  desc 'Generates breadcrumbs for all curriculum items'
  task generate_breadcrumbs: [:environment] { CurriculumTasks.generate_breadcrumbs }

  desc 'Generates hierarchical positions for all curriculum items'
  task generate_positions: [:environment] { CurriculumTasks.generate_hierarchical_positions }

  desc 'Generates short titles (for Lessons resource only)'
  task generate_short_titles: [:environment] { CurriculumTasks.generate_resources_short_titles }

  desc 'Reset resource slugs'
  task reset_slugs: [:environment] { CurriculumTasks.reset_slugs }

  desc 'Syncs reading assignments for curriculum items'
  task sync_reading_assignments: [:environment] { CurriculumTasks.sync_reading_assignments }

  desc 'Updates time to teach across curriculums'
  task update_time_to_teach: [:environment] { CurriculumTasks.update_time_to_teach }

  desc 'Create Google Drive folder hierarchy'
  task gdrive_folders: [:environment] { GoogleDriveFolders.new.run }
end
