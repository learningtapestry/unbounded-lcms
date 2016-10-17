
namespace :unbounded do
  namespace :sweeper do

    desc 'Process files in a directory (see issue 411)'
    task process: [:environment] do
      path = ENV['dir']
      unless path
        puts "Usage example: rake unbounded:sweeper:process dir=<full_path>"
      else
        sweeper = Sweeper.new
        sweeper.process_directory(path)
      end
    end

  end

end

