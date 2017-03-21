namespace :cache do
  desc 'Clears up Rails cache store'
  task clear: [:environment] { Rails.cache.clear }

  desc  'Reset content guides'
  task reset_content_guides: :environment do
    Rails.cache.pool.with do |client|
      prefix = Rails.cache.options[:namespace]
      client.keys("#{prefix}:content_guides:*").each { |key| client.del(key) }
    end
  end
end
