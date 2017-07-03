namespace :oneoff do
  # desc "Solve issue N"
  # task issue_N: :environment do
  #   Oneoff.fix 'N'
  # end

  task fix_assessments_tree: :environment do
    Document.all.each do |l|
      if l.resource.try(:assessment?)
        curr = l.resource.curriculums.first
        curr.update seed_id: curr.parent.seed_id
      end
    end
  end

  task migrate_data_after_refactor: :environment do
    tree = File.read Rails.root.join('db', 'data', 'pilot_curriculum_tree.json')
    CurriculumTree.default.update tree: JSON.parse(tree)

    Rake::Task['resources:curriculum_directories'].invoke
    Rake::Task['resources:generate_positions'].invoke
    Rake::Task['resources:fix_lessons_metadata'].invoke
    Rake::Task['resources:generate_slugs'].invoke
    Rake::Task['es:reset'].invoke
    Rake::Task['es:load'].invoke
  end
end
