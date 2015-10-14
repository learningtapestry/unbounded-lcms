include Content::Models

after :organizations do

  module_title = 'Grade 9 ELA Writing Module'

  Lobject.by_title(module_title).first || Lobject.transaction do
    root_lobject = LobjectBuilder.new
      .set_organization(Organization.unbounded)
      .add_title(module_title)
      .save!

    grade_9_lobject = Lobject.by_title('Grade 9 English Language Arts').first
    grade_9_collection = grade_9_lobject.curriculum_map_collection
    grade_9_collection.add_child(root_lobject)

    module_structure = {
      "#{module_title}, Unit 1 - Keep on Reading" => 20,
      "#{module_title}, Unit 2 - Informative Writing" => 20,
      "#{module_title}, Unit 3 - Narrative Writing" => 19
    }

    module_structure.each do |unit_title, lesson_count|
      unit = LobjectBuilder.new
        .set_organization(Organization.unbounded)
        .add_title(unit_title)
        .save!

      puts "#{unit.id} - #{unit.title}"

      grade_9_collection.add_child(unit, parent: root_lobject)

      lesson_count.times do |i|
        lesson_no = i+1

        lesson = LobjectBuilder.new
          .set_organization(Organization.unbounded)
          .add_title("#{unit_title}, Lesson #{lesson_no}")
          .save!

          puts "#{lesson.id} - #{lesson.title}"

        grade_9_collection.add_child(lesson, parent: unit)
      end
    end

    grade_9_collection.save!
  end

end
