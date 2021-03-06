# frozen_string_literal: true

Rails.application.config.redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))
