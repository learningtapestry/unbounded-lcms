namespace :es do

  desc 'Load index'
  task load: :environment do
    models = [ Resource, ContentGuide]

    repo = Search::Repository.new
    repo.create_index!

    models.each do |model|
      puts "Loading Index for: #{model.name}"
      model.find_in_batches do |group|
        group.each { |item| Search::Document.build_from(item).index! }
      end
    end
  end
end
