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
end
