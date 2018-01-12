namespace :oneoff do
  task fix_math_docs_module_metadata: :environment do
    puts '====> Fix Math Documents Module Metadata'
    Document.filter_by_subject('math').each do |d|
      d.metadata['module'] = d.metadata['unit'] unless d.metadata['module']
      d.save
    end
  end

  # related to https://github.com/learningtapestry/unbounded/pull/669
  # should be run once for fixing the modules curriculum (if needed)
  task fix_alphanum_modules: :environment do
    Resource.tree.modules.select do |r|
      !r.curriculum_directory.any? { |s| s =~ /module/ } && r.short_title =~ /^\w+$/
    end.each do |r|
      r.curriculum_directory.delete(r.short_title)
      mod = "module #{r.short_title.downcase}"
      r.short_title = mod
      r.curriculum_directory <<  mod
      r.save

      r.children.each do |u|
        u.curriculum_directory << mod
        u.save
        u.children.each { |l| l.curriculum_directory << mod; l.save }
      end
    end
  end
end
