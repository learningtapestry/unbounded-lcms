namespace :word_files do
  desc 'Process files in a directory (see issue 411)'
  task process: [:environment] do
    path = ENV['WORD_FILES_DIR']
    unless path
      puts "Usage example: rake word_files:process WORD_FILES_DIR=<full_path>"
    else
      WordFilesProcessor.process(path)
    end
  end
end

