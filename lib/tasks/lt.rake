namespace :lt do
  desc 'Post-deployment tasks.'
  task deploy: [:environment, :'db:seed']
end
