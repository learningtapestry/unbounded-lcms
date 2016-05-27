namespace :standards do

  desc 'Import all CCSS standards from Common Standards Project'
  task import: [:environment] do
    Standard.import
    puts "Imported all CCSS standards from Common Standards Project."
  end

  desc 'Update alt_names for all CCSS standards'
  task update_alt_names: [:environment] do
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
