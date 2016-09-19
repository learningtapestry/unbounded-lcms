
# Autoreload changed /lib files in development mode

if Rails.env == "development"
  Dir["lib/**/*.rb"].each do |fn|
    require_dependency File.expand_path(fn) # require_dependency() reloads automatically!
  end
end

