namespace :lt do
  desc 'Post-bundle hook tasks for Cloud66.'
  task c66_after_bundle: [:'i18n:js:export']

  desc 'Post-symlink hook tasks for Cloud66.'
  task c66_after_symlink: [:environment, :'db:migrate', :'db:seed']
end
