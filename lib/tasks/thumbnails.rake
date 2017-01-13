namespace :thumbnails do
  desc 'generate thumbnail images'
  task generate: [:environment] do
    # generate_thumbnails 'Resources', Curriculum.trees
    #                                      .with_resources
    #                                      .includes(:resource_item)
    generate_thumbnails 'Media    ', Resource.media
    generate_thumbnails 'Generic  ', Resource.generic_resources
    generate_thumbnails 'Guide    ', ContentGuide.where(nil)
  end

  def build_progressbar(name, qset)
    ProgressBar.create title: "Generate thumbnails for #{name}", total: qset.count()
  end

  def generate_thumbnails(name, qset)
    pbar = build_progressbar name, qset

    qset.find_in_batches do |group|
      group.each do |item|
        GenerateThumbnails.new(item).generate
        pbar.increment
      end
    end
    pbar.finish
  end
end
