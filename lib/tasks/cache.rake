namespace :cache do
  desc 'Clears up Rails cache store'
  task clear: [:environment] { Rails.cache.clear }
end
