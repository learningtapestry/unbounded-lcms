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
    once = false
    qset.find_in_batches do |group|
      group.each do |item|
        GenerateThumbnails.new(item).generate
        pbar.increment
      end
      # convert whole group to png at once
      puts "Converting to PNG"
      gen = GenerateThumbnails.new(nil)
      all_svgs = Dir[gen.tmp_dir.join('*.svg')]
      gen.convert_to_png(gen.tmp_dir.join('*.svg'))

      puts "Uploading to S3"
      Dir[gen.tmp_dir.join('*.png')].each do |path|
        # save files to s3
        fname = path.split('/').last
        info = fname.match /^(.*)_(\d+)_(\w+)\.png/

        klass = info[1] == 'content_guide' ? ContentGuide : Resource
        id    = info[2].to_i
        media = info[3]
        target = klass.find(id)

        thumb = SocialThumbnail.find_or_initialize_by(media: media, target: target)
        thumb.image = File.open(path)
        thumb.save
        print '.'
      end

      puts "\nRemove tmp files"
      # remove files
      files = Dir.glob(gen.tmp_dir.join "*.{svg,png}")
      FileUtils.rm files
    end
    pbar.finish
  end
end
