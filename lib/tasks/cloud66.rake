namespace :cloud66 do
  desc 'Post-bundle hook tasks for Cloud66.'
  task after_bundle: [:'i18n:js:export', :'routes:generate_js']

  desc 'Post-symlink hook tasks for Cloud66.'
  task after_symlink: [:environment, :'db:migrate', :'db:seed']
end
