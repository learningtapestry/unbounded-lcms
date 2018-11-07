# frozen_string_literal: true

namespace :es do # rubocop:disable Metrics/BlockLength
  desc 'Indexes models'
  task index_models: :environment do
    index_model 'Guide    ', ContentGuide.where(nil)
  end
end
