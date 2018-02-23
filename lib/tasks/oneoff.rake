# frozen_string_literal: true

namespace :oneoff do # rubocop:disable Metrics/BlockLength
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
    Resource.tree.modules
      .select { |r| r.curriculum_directory.none? { |s| s =~ /module/ } && r.short_title =~ /^\w+$/ }
      .each do |r|
        r.curriculum_directory.delete(r.short_title)
        mod = "module #{r.short_title.downcase}"
        r.short_title = mod
        r.curriculum_directory << mod
        r.save

        r.children.each do |u|
          u.curriculum_directory << mod
          u.save
          u.children.each do |l|
            l.curriculum_directory << mod
            l.save
          end
        end
      end
  end

  task fix_level_positions: :environment do
    def consecutive?(l)
      l.zip(0..l.size).all? { |num, index| num == index }
    end

    def fix_positions(res)
      puts "Fix order for #{res.slug}"
      puts "from #{res.children.pluck(:level_position).inspect}"
      res.children.each_with_index do |r, index|
        if r.level_position != index
          r.level_position = index
          r.save!
        end
      end
      puts "to   #{res.reload.children.pluck(:level_position).inspect}\n\n"
    end

    def check_node(r)
      fix_positions(r) unless consecutive? r.children.pluck(:level_position)
      r.children.each { |c| check_node c }
    end

    Resource.tree.roots.each { |r| check_node(r) }
  end
end
