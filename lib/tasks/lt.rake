namespace :lt do
  desc 'Post-deployment tasks for Cloud66 (require ubuntu user permissions).'
  task c66_ubuntu_deploy: [:'i18n:js:export']

  desc 'Post-deployment tasks for Cloud66 (standard user).'
  task c66_deploy: [:environment, :'db:migrate', :'db:seed']

  desc 'Post-deployment tasks.'
  task deploy: [:c66_ubuntu_deploy, :c66_deploy]
end
