curriculums = {
  unbounded: 'unbounded_curriculum_tree.json',
  pilot:     'pilot_curriculum_tree.json'
}

curriculums.each do |name, filename|
  puts "====> Loading CurriculumTree for '#{name}'"

  content = File.read Rails.root.join('db', 'data', filename)
  tree = JSON.parse content

  CurriculumTree.create_with(tree: tree).find_or_create_by!(name: name)
end

# Set the 'pilot' as default if we don't have any already set
if CurriculumTree.where(default: true).empty?
  CurriculumTree.find_by(name: 'pilot').update default: true
end
