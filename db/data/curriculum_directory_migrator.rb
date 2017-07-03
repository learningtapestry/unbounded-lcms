class CurriculumDirectoryMigrator
  def migrate!
    puts "== Resources curriculum_directory data migration\n"
    Resource.all.each do |res|
      curr = Curriculum.where(item_id: res.id, item_type: 'Resource').trees.first
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
    grade_list = Tagging
                   .where(taggable_type: 'Resource', taggable_id: res.id, context: 'grades')
                   .map { |t| t.tag.name }
    (grade_list & Grades::GRADES).each { |grade| dir << grade }

    dir << 'assessment' if res.tag_list.include?('assessment')
    dir.compact.uniq.map(&:downcase)
  end

  def type(res, curr = nil)
    return type_from_curriculum(curr) if curr.present?

    case res.short_title
    when /lesson|part|assessment/ then 'lesson'
    when /unit/ then 'unit'
    when /module/ then 'module'
    when /grade/ then 'grade'
    when /ela|math/ then 'subject'
    end
  end

  def type_from_curriculum(curr)
    ctype = curr.curriculum_type.name.downcase
    ctype == 'map' ? 'subject' : ctype
  end
end
