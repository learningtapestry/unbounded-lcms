namespace :es do

  desc 'Load index'
  task load: :environment do
    models = [ Resource, ContentGuide]

    repo = Search::Repository.new
    repo.create_index!


    models.each do |model|
      pbar = ProgressBar.create title: "Indexing #{model.name}", total: model.count()

      model.find_in_batches do |group|
        group.each do |item|
          Search::Document.build_from(item).index!
          pbar.increment
        end
      end
      pbar.finish
    end
  end
end
