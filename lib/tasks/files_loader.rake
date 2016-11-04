namespace :files_loader do
  desc 'Process files in a directory (see issue 411)'
  task :load, [:module_extension] => [:environment] do |t, args|
    path = ENV['FILES_DIR']
    unless path
      puts "Usage example: rake files_loader:load[module_extension] FILES_DIR=<full_path>"
    else
      FilesLoader::load! path, args[:module_extension]
    end
  end
end

