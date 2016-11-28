namespace :es do

  desc 'Reset Index'
  task reset: :environment do
    if repo.index_exists?
      puts "Deleting Index: #{repo.index}"
      repo.delete_index!
    end

    puts "Creating Index: #{repo.index}"
    repo.create_index!
  end

  desc 'Load index'
  task load: :environment do
    repo.create_index!

    index_model 'Resources', Curriculum.trees.with_resources.includes(:resource_item)
    index_model 'Media    ', Resource.media
    # index_model 'Generic  ', Resource.generic_resources
    index_model 'Guide    ', ContentGuide.where(nil)
  end

  def repo
    @repo ||= Search::Repository.new
  end

  def build_progressbar(name, qset)
    ProgressBar.create title: "Indexing #{name}", total: qset.count()
  end

  def index_model(name, qset)
    pbar = build_progressbar name, qset

    qset.find_in_batches do |group|
      group.each do |item|
        Search::Document.build_from(item).index!
        pbar.increment
      end
    end
    pbar.finish
  end
end
