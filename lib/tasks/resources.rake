namespace :resources do
  desc 'Fixes formatting for resources'
  task fix_formatting: [:environment] { ResourceTasks.fix_formatting }
end
