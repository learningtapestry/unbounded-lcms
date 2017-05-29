class CurriculumTreeMigrator
  def migrate!
    curriculums.each do |name, filename|
      puts "====> Loading CurriculumTree for '#{name}'"

      tree = JSON.parse fixture(filename)

      CurriculumTree.create_with(tree: tree).find_or_create_by!(name: name)
    end

    # Set the 'pilot' as default if we don't have any already set
    CurriculumTree.find_by(name: 'pilot').update(default: true) unless CurriculumTree.exists?(default: true)
  end

  def curriculums
    {
      unbounded: 'unbounded_curriculum_tree.json',
      pilot:     'pilot_curriculum_tree.json'
    }
  end

  def fixture(filename)
    File.read Rails.root.join('db', 'data', filename)
  end
end
