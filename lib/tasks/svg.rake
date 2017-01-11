namespace :svg do

  desc 'generate svg files'
  task generate: [:environment] do
    qset = CommonCoreStandard.where(nil)
    pbar = ProgressBar.create title: "Alt Names", total: qset.count()

    qset.find_in_batches do |group|
      group.each do |std|
        std.generate_alt_names
        std.save
        pbar.increment
      end
    end
    pbar.finish
  end
end

    # index_model 'Resources', Curriculum.trees
    #                                    .with_resources
    #                                    .where.not(curriculum_type: CurriculumType.map)
    #                                    .includes(:resource_item)
    # index_model 'Media    ', Resource.media
    # index_model 'Generic  ', Resource.generic_resources
    # index_model 'Guide    ', ContentGuide.where(nil)
