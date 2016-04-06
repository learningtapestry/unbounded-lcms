namespace :curriculum do
  desc 'Generates breadcrumbs for all curriculum items'
  task generate_breadcrumbs: [:environment] { CurriculumTasks.generate_breadcrumbs }
end
