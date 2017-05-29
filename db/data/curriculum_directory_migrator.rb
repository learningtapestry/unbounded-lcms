class CurriculumDirectoryMigrator
  def migrate!
    puts "== Resources curriculum_directory data migration\n"
    Resource.all.each do |res|
      curr = res.first_tree
      res.curriculum_directory = directory(res, curr)
      res.curriculum_type = type(res, curr)
      res.curriculum_tree = CurriculumTree.default if curr
      res.save
      print '.'
    end
    puts "\n"
  end

  private

  def directory(res, curr = nil)
    dir = if curr
            curr.self_and_ancestors.map { |c| c.resource.short_title }.reverse
          else
            dir = []
          end
    dir << res.subject if res.subject.present?
    (res.grade_list & GradeListHelper::GRADES).each { |grade| dir << grade }

    dir.compact.uniq.map(&:downcase)
  end

  def type(res, curr = nil)
    return curr.curriculum_type.name.downcase if curr.present?

    case res.short_title
    when /lesson/ then 'lesson'
    when /unit/ then 'unit'
    when /module/ then 'module'
    when /grade/ then 'grade'
    end
  end
end
