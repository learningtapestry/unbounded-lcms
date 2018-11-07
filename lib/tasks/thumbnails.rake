# frozen_string_literal: true

namespace :thumbnails do # rubocop:disable Metrics/BlockLength
  desc 'generate thumbnail images'
  namespace :generate do
    task others: [:environment] do
      generate_thumbnails 'Guide    ', ContentGuide.where(nil)
    end
  end

  # rubocop:disable Style/DateTime
  task update: [:environment] do
    update_thumbs ContentGuide.where('updated_at > ?', last_update)
  end
  # rubocop:enable Style/DateTime
end
