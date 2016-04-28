namespace :es do

  desc 'Load index'
  task load: :environment do
    models = [ Resource, ContentGuide ]

    repo = Search::Repository.new
    repo.create_index!


    models.each do |model|
      is_resource = model == Resource
      qset = is_resource ? Curriculum.trees.with_resources.includes(:resource_item) : model
      pbar = ProgressBar.create title: "Indexing #{model.name}", total: qset.count()

      qset.find_in_batches do |group|
        group = group.map(&:resource_item) if is_resource

        group.each do |item|
          Search::Document.build_from(item).index!
          pbar.increment
        end
      end
      pbar.finish
    end
  end
end
