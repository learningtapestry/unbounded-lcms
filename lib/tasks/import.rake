namespace :import do
  desc 'Process files in a directory (see issue 411)'
  task generic_resources: :environment do
    files_dir = ENV['FILES_DIR']
    csv_path = ENV['CSV_PATH']

    unless csv_path && files_dir
      puts "Usage example: rake import:generic_resources CSV_PATH=<full_path> FILES_DIR=<full_path>"
    else
      GenericResourcesImporter.new(csv_path, files_dir).run!
    end
  end
end

