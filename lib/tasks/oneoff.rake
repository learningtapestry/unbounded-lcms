namespace :oneoff do
  # desc "Solve issue N"
  # task issue_N: :environment do
  #   Oneoff.fix 'N'
  # end

  task fix_assessments_tree: :environment do
    LessonDocument.all.each do |l|
      if l.resource.try(:assessment?)
        curr = l.resource.curriculums.first
        curr.update seed_id: curr.parent.seed_id
      end
    end
  end

  task unit2_resources: :environment do
    with_curriculum = true

    # ELA Grade 2 UNIT 2 Lessons 1-17 (unit + lessons)
    create_unit2_resources(2, 17, with_curriculum)
    # ELA Grade 6 UNIT 2 Lessons 1-14 (unit + lessons)
    create_unit2_resources(6, 14, with_curriculum)
  end

  def create_unit2_resources(grade, lessons, with_curriculum)
    mod = Curriculum.ela.seeds.grades
      .where_grade("grade #{grade}")
      .first # The grade
      .children # The modules
      .first # The first module
      .curriculum_item # The curriculum item for the first module

    puts "Found module #{mod.id} - #{mod.resource.title}"

    # Create unit
    resource = Resource.create!(
      curriculum_directory: ['ela', "grade #{grade}", 'module 1', 'unit 2'],
      curriculum_type: 'unit',
      grade_list: ["grade #{grade}"],
      resource_type: Resource.resource_types[:resource],
      short_title: 'unit 2',
      subject: 'ela',
      title: "ELA G#{grade} M1 U2"
    )

    if with_curriculum
      unit = Curriculum.create!(
        curriculum_type: CurriculumType.unit,
        item: resource,
        breadcrumb_title: "ELA / G#{grade} / M1 / unit 2",
        breadcrumb_short_title: "EL / G#{grade} / M1 / U2",
        breadcrumb_piece: 'U2',
        breadcrumb_short_piece: 'U2',
        hierarchical_position: "01 01 #{grade.to_s.rjust(2, '0')} 00"
      )
      mod.children.create!(
        curriculum_type: CurriculumType.unit,
        item: unit,
        position: 1,
        breadcrumb_title: "ELA / G#{grade} / M1 / unit 2",
        breadcrumb_short_title: "EL / G#{grade} / M1 / U2",
        breadcrumb_piece: 'U2',
        breadcrumb_short_piece: 'U2',
        hierarchical_position: "01 01 #{grade.to_s.rjust(2, '0')} 00"
      )
    end

    lessons.times do |i|
      num = i + 1
      resource = Resource.create!(
        curriculum_directory: ['ela', "grade #{grade}", 'module 1', 'unit 2', "lesson #{num}"],
        curriculum_type: 'lesson',
        grade_list: ["grade #{grade}"],
        resource_type: Resource.resource_types[:resource],
        short_title: "lesson #{num}",
        subject: 'ela',
        title: "ELA G#{grade} M1 U2 L#{num}"
      )
      if with_curriculum
        unit.children.create!(
          curriculum_type: CurriculumType.lesson,
          item: resource,
          seed_id: unit.seed_id,
          position: num,
          breadcrumb_title: "ELA / G#{grade} / M1 / U2 / lesson #{num}",
          breadcrumb_short_title: "EL / G#{grade} / M1 / U2 / L#{num}",
          breadcrumb_piece: "L#{num}",
          breadcrumb_short_piece: "L#{num}",
          hierarchical_position: "01 01 #{grade.to_s.rjust(2, '0')} #{num.to_s.rjust(2, '0')}"
        )
      end
    end

    Curriculum.maps.seeds.each { |c| c.create_tree(force: true) }
  end
end
