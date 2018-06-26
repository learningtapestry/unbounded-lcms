# frozen_string_literal: true

SUBJECTS = {
  ela: 'English Language Arts (ELA)',
  math: 'Mathematics (Math)'
}.freeze

SUBJECTS.each do |short_title, title|
  Resource.find_or_create_by(curriculum_type: 'subject',
                             short_title: short_title) do |r|
    r.metadata = { subject: short_title }
    r.title = title
    r.tree = true
    r.curriculum_id = Curriculum.default&.id
  end
end

GRADES = [
  { name: 'prekindergarten', short_name: 'PK', long_name: 'Pre-Kindergarden', band: 'Early Learning' },
  { name: 'kindergarten', short_name: 'K', long_name: 'Kindergarden', band: 'Elementary School' },
  { name: 'grade 1', short_name: '1', long_name: 'Grade 1', band: 'Elementary School' },
  { name: 'grade 2', short_name: '2', long_name: 'Grade 2', band: 'Elementary School' },
  { name: 'grade 3', short_name: '3', long_name: 'Grade 3', band: 'Elementary School' },
  { name: 'grade 4', short_name: '4', long_name: 'Grade 4', band: 'Elementary School' },
  { name: 'grade 5', short_name: '5', long_name: 'Grade 5', band: 'Elementary School' },
  { name: 'grade 6', short_name: '6', long_name: 'Grade 6', band: 'Middle School' },
  { name: 'grade 7', short_name: '7', long_name: 'Grade 7', band: 'Middle School' },
  { name: 'grade 8', short_name: '8', long_name: 'Grade 8', band: 'Middle School' },
  { name: 'grade 9', short_name: '9', long_name: 'Grade 9', band: 'High School',
    math_name: 'Algebra 1 (A1)', math_abbrv: 'A1' },
  { name: 'grade 10', short_name: '10', long_name: 'Grade 10', band: 'High School',
    math_name: 'Geometry (GE)', math_subject_abbrv: 'GE' },
  { name: 'grade 11', short_name: '11', long_name: 'Grade 11', band: 'High School',
    math_name: 'Algebra 2 (A2)', math_abbrv: 'A2' },
  { name: 'grade 12', short_name: '12', long_name: 'Grade 12', band: 'High School',
    math_name: 'Pre-Calculus (PC)', math_abbrv: 'PC' }
].freeze

# rubocop:disable Metrics/BlockLength
Resource.subjects.each do |subject|
  subject.update! title: SUBJECTS[subject.short_title.to_sym]

  GRADES.each_with_index do |grade, index|
    puts "----> #{subject.title} #{grade[:name]}"
    res = subject.children.detect { |r| r.short_title == grade[:name] }

    metadata = {
      subject: subject.short_title,
      grade: grade[:name],
      grade_band: grade[:band],
      grade_subject_name: grade[:math_name].presence || subject.title,
      grade_abbrv: grade[:math_abbrv].presence || grade[:short_name]
    }.compact

    if res
      res.title = grade[:long_name]
      res.level_position = index
      res.metadata = metadata
      res.save!
    else
      subject.children.create!(
        short_title: grade[:name],
        title: grade[:long_name],
        level_position: index,
        resource_type: Resource.resource_types[:resource],
        curriculum: Curriculum.default,
        curriculum_type: 'grade',
        tree: true,
        metadata: metadata
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
