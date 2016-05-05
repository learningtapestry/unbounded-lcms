# Math Grade 6 Module 1
if (resource = ResourceSlug.find_by_value('math/grade-6/module-1').try(:resource))
  standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'm-g6')
  resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
end

# ELA K, 1, 2 (all units)
standard = UnboundedStandard.create_with(subject: 'ela').find_or_create_by!(name: 'ela-k2')
Curriculum.ela.where_grade(['kindergarten', 'grade 1', 'grade 2']).units.includes(:item).map(&:resource).uniq.each do |resource|
  resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
end
