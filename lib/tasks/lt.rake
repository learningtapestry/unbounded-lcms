namespace :lt do
  desc 'Post-deployment tasks.'
  task deploy: [
    :environment,
    :'i18n:js:export',
    :'db:seed'
  ]
end
