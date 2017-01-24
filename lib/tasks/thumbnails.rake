namespace :thumbnails do
  desc 'generate thumbnail images'
  namespace :generate do
    task resources: [:environment] do
      generate_thumbnails 'Resources', Curriculum.trees
                                                 .with_resources
                                                 .includes(:resource_item)
    end

    task others: [:environment] do
      generate_thumbnails 'Media    ', Resource.media
      generate_thumbnails 'Generic  ', Resource.generic_resources
      generate_thumbnails 'Guide    ', ContentGuide.where(nil)
    end

    task all: [:others, :resources] do
    end

    def build_progressbar(name, qset)
      ProgressBar.create title: "Generate thumbnails for #{name}", total: qset.count()
    end

    def generate_thumbnails(name, qset)
      pbar = build_progressbar name, qset
      once = false
      qset.find_in_batches do |group|
        group.each do |item|
          GenerateThumbnails.new(item).generate
          pbar.increment
        end
      end
      pbar.finish
    end
  end
end
