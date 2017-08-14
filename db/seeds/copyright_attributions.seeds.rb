# class << self
#   def add_copyright(curriculums, value, with_disclaimer: true)
#     disclaimer = 'UnboundEd is not affiliated with the copyright holder of this work.' if with_disclaimer
#     curriculums.trees.each do |curriculum|
#       curriculum.resource.copyright_attributions.create_with(disclaimer: disclaimer).find_or_create_by!(value: value)
#     end
#   end
# end
#
# # ELA / grades PK, K, 1, 2
# add_copyright(Curriculum.ela.grades.where_grade(['prekindergarten', 'kindergarten', 'grade 1', 'grade 2']),
#                'This work is based on an original work of the Core Knowledge® Foundation made available through licensing under a Creative Commons AttributionNonCommercial-ShareAlike 3.0 Unported License. This does not in any way imply that the Core Knowledge Foundation endorses this work.',
#                with_disclaimer: false)
#
# # ELA / grades 3, 5
# add_copyright(Curriculum.ela.grades.where_grade(['grade 3', 'grade 5']), '© 2015 EL Education Inc.')
#
# # ELA / grade 4
# add_copyright(Curriculum.ela.grades.where_grade('grade 4'), 'Copyright © 2014 NYSED, Albany, NY. All Rights Reserved.')
# add_copyright(Curriculum.ela.grades.where_grade('grade 4'), '© 2015 EL Education Inc.')
# 
# # ELA / grade 4 /module 1A
# add_copyright(Curriculum.where(breadcrumb_short_title: 'EL / G4 / M1A'), 'Copyright © 2014 NYSED, Albany, NY. All Rights Reserved.')
#
# # ELA / grade 4 / all modules, except 1A
# add_copyright(Curriculum.ela.modules.where_grade('grade 4').where.not(breadcrumb_short_title: 'EL / G4 / M1A'),
#               '© 2015 EL Education Inc.')
#
# # ELA / grade 6, 7
# add_copyright(Curriculum.ela.grades.where_grade(['grade 6', 'grade 7']),
#               'Created by Expeditionary Learning, on behalf of Public Consulting Group, Inc. © Public Consulting Group, Inc., with a perpetual license granted to Expeditionary Learning Outward Bound, Inc.')
#
# # ELA / grade 8
# add_copyright(Curriculum.ela.grades.where_grade('grade 8'), 'Created by Expeditionary Learning, on behalf of Public Consulting Group, Inc. © Public Consulting Group, Inc., with a perpetual license granted to Expeditionary Learning Outward Bound, Inc.')
# add_copyright(Curriculum.ela.grades.where_grade('grade 8'), '© 2015 EL Education Inc.')
#
# # ELA / grade 8 / all modules, expect 4
# add_copyright(Curriculum.ela.modules.where_grade('grade 8').where.not(breadcrumb_short_title: 'EL / G8 / M4'),
#               'Created by Expeditionary Learning, on behalf of Public Consulting Group, Inc. © Public Consulting Group, Inc., with a perpetual license granted to Expeditionary Learning Outward Bound, Inc.')
#
# # ELA / grade 8 / module 4
# add_copyright(Curriculum.where(breadcrumb_short_title: 'EL / G8 / M4'), '© 2015 EL Education Inc.')
#
# # ELA / grades 9—12
# add_copyright(Curriculum.ela.grades.where_grade(['grade 9', 'grade 10', 'grade 11', 'grade 12']), '© 2014 Public Consulting Group.')
#
# # Math, all grades
# add_copyright(Curriculum.math.grades, 'Copyright © 2015 Great Minds.')
