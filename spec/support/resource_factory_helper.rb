module ResourceFactoryHelper
  def resources_sample_collection
    # ELA G2 => 2 lessons
    2.times do |i|
      pos = i + 1
      create(:resource,
             title: "Test Resource ELA G2 L#{pos}",
             curriculum_directory: ['ela', 'grade 2', 'module 1', 'unit 1', "lesson #{pos}"])
    end

    # ELA G6 => 6 lessons
    6.times do |i|
      pos = i + 1
      create(:resource,
             title: "Test Resource ELA G6 L#{pos}",
             curriculum_directory: ['ela', 'grade 6', 'module 1', 'unit 1', "lesson #{pos}"])
    end

    # Math G4 => 4 lessons
    4.times do |i|
      pos = i + 1
      create(:resource,
             title: "Test Resource Math G4 L#{pos}",
             curriculum_directory: ['math', 'grade 4', 'module 1', 'unit 1', "lesson #{pos}"])
    end

    # Math G7 => 7 lessons
    7.times do |i|
      pos = i + 1
      create(:resource,
             title: "Test Resource Math G7 L#{pos}",
             curriculum_directory: ['math', 'grade 7', 'module 1', 'unit 1', "lesson #{pos}"])
    end
  end

  def build_resources_chain(curr)
    dir = []
    Resource::HIERARCHY.each_with_index do |type, idx|
      next unless curr[idx]
      dir.push curr[idx]
      create(:resource,
             title: "Test Resourece #{dir.join('|')}",
             curriculum_type: type,
             curriculum_directory: dir)
    end
  end
end
