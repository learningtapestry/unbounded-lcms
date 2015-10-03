namespace :lt do
  desc 'Post-deployment tasks.'
  task deploy: [
    :environment,
    :'tmp:clear',
    :'db:seed'
  ]
end
