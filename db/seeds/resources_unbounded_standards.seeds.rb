# # ELA Grade K (ALL UNITS), ELA GRADE 1 (ALL UNITS), ELA GRADE 2 (ALL UNITS)
# standard = UnboundedStandard.create_with(subject: 'ela').find_or_create_by!(name: 'ela-k2-cg')
# Curriculum.ela.where_grade(['kindergarten', 'grade 1', 'grade 2']).units.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ELA GRADE 3 (ALL UNITS), ELA GRADE 4 (ALL UNITS), ELA GRADE 5 (ALL UNITS)
# standard = UnboundedStandard.create_with(subject: 'ela').find_or_create_by!(name: 'ela-35-cg')
# Curriculum.ela.where_grade(['grade 3', 'grade 4', 'grade 5']).units.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ELA GRADE 6 (ALL UNITS), ELA GRADE 7 (ALL UNITS), ELA GRADE 8 (ALL UNITS), ELA GRADE 9 (ALL UNITS), ELA GRADE 10 (ALL UNITS), ELA GRADE 11 (ALL UNITS), ELA GRADE 12 (ALL UNITS)
# standard = UnboundedStandard.create_with(subject: 'ela').find_or_create_by!(name: 'ela-612-cg')
# Curriculum.ela.where_grade(['grade 6', 'grade 7', 'grade 8', 'grade 9', 'grade 9', 'grade 10', 'grade 11', 'grade 12']).units.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ELA PK - all modules, ELA K - all modules, ELA 1 - all modules, ELA 2 - all modules
# standard = UnboundedStandard.create_with(subject: 'ela').find_or_create_by!(name: 'ela-podcast-pk2')
# Curriculum.ela.where_grade(['prekindergarten', 'kindergarten', 'grade 1', 'grade 2']).modules.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ELA PreK - all modules, ELA K all modules
# standard = UnboundedStandard.create_with(subject: 'ela').find_or_create_by!(name: 'ela-video-pkk')
# Curriculum.ela.where_grade(['prekindergarten', 'kindergarten']).modules.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # MATH K Module 1, MATH K Module 3
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-k-cg')
# Resource.distinct.joins(:resource_slugs).where(resource_slugs: { value: %w(math/kindergarten/module-1 math/kindergarten/module-3) }).each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # MATH Grade 1 Module 1, MATH Grade 1 Module 2, MATH Grade 1 Module 3
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-1-cg')
# Resource.distinct.joins(:resource_slugs).where(resource_slugs: { value: %w(math/grade-1/module-1 math/grade-1/module-2 math/grade-1/module-3) }).each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # MATH Grade 2 Module 1, MATH Grade 2 Module 4
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-2-cg')
# Resource.distinct.joins(:resource_slugs).where(resource_slugs: { value: %w(math/grade-2/module-1 math/grade-2/module-4) }).each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # MATH Grade 6 Module 1
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-6-cg')
# Resource.distinct.joins(:resource_slugs).where(resource_slugs: { value: %w(math/grade-6/module-1) }).each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # MATH Grade 7 Module 1, MATH Grade 7 Module 4
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-7-cg')
# Resource.distinct.joins(:resource_slugs).where(resource_slugs: { value: %w(math/grade-7/module-1 math/grade-7/module-4) }).each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # MATH Grade 8 Module 1, MATH Grade 8 Module 2, MATH Grade 8 Module 7
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-8-cg')
# Resource.distinct.joins(:resource_slugs).where(resource_slugs: { value: %w(math/grade-8/module-1 math/grade-8/module-2 math/grade-8/module-7) }).each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ALL MATH Grade 6 modules
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-video-6')
# Curriculum.math.where_grade(['grade 6']).modules.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ALL MATH Grade K and MATH Grade 1 Modules
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-video-k1')
# Curriculum.math.where_grade(['kindergarten', 'grade 1']).modules.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
#
# # ALL MATH Grade K and MATH Grade 1 Modules, MATH Grade 2 Modules
# standard = UnboundedStandard.create_with(subject: 'math').find_or_create_by!(name: 'math-video-k2')
# Curriculum.math.where_grade(['kindergarten', 'grade 1', 'grade 2']).modules.includes(:item).map(&:resource).uniq.each do |resource|
#   resource.unbounded_standards << standard unless resource.unbounded_standards.include?(standard)
# end
