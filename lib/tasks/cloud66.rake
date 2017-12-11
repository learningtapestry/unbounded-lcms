# frozen_string_literal: true

namespace :cloud66 do
  desc 'Post-bundle hook tasks for Cloud66.'
  task after_bundle: %i(i18n:js:export routes:generate_js)

  desc 'Post-symlink hook tasks for Cloud66.'
  task after_symlink: %i(environment db:migrate db:seed)

  namespace :robots do
    desc 'Add robots.txt to public'
    task add: :environment do
      origin = Rails.root.join '.cloud66', 'public', 'staging', 'robots.txt'
      target = Rails.root.join 'public'
      FileUtils.cp origin, target
    end

    desc 'Deletes robots.txt from public'
    task remove: :environment do
      path = Rails.root.join 'public', 'robots.txt'
      FileUtils.rm path
    end
  end
end
