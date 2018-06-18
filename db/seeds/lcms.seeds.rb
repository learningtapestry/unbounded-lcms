# frozen_string_literal: true

# create root nodes only for the tree
Resource.find_or_create_by(short_title: 'ela') do |r|
  r.title = 'English Language Arts (ELA)'
  r.resource_type = 1
  r.curriculum_type = 'subject'
  r.level_position = 0
  r.tree = true
  r.curriculum_directory = ['ela']
  r.subject = 'ela'
end

Resource.find_or_create_by(short_title: 'math') do |r|
  r.title = 'Mathematics (Math)'
  r.resource_type = 1
  r.curriculum_type = 'subject'
  r.level_position = 1
  r.tree = true
  r.curriculum_directory = ['math']
  r.subject = 'math'
end
