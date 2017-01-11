namespace :svg do
  desc 'generate svg files'
  task generate: [:environment] do
    generate_svgs 'Resources', Curriculum.trees
                                         .with_resources
                                         .includes(:resource_item)
    generate_svgs 'Media    ', Resource.media
    generate_svgs 'Generic  ', Resource.generic_resources
    generate_svgs 'Guide    ', ContentGuide.where(nil)
  end

  def build_progressbar(name, qset)
    ProgressBar.create title: "Generate SVG for #{name}", total: qset.count()
  end

  def generate_svgs(name, qset)
    pbar = build_progressbar name, qset

    qset.find_in_batches do |group|
      group.each do |item|
        [:all, :facebook, :pinterest, :twitter].each do |media|
          GenerateSVGThumbnailService.new(item, media: media).run
        end
        pbar.increment
      end
    end
    pbar.finish
  end
end
