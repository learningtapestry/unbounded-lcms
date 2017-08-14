namespace :oneoff do
  task migrate_data_after_refactor: :environment do
    # related to issue 191
    # after all envs were migrated we can remove this
    tree = File.read Rails.root.join('db', 'data', 'pilot_curriculum_tree.json')
    CurriculumTree.default.update tree: JSON.parse(tree)

    Rake::Task['resources:curriculum_directories'].invoke
    Rake::Task['resources:generate_positions'].invoke
    Rake::Task['resources:fix_lessons_metadata'].invoke
    Rake::Task['resources:generate_slugs'].invoke
    # Rake::Task['es:reset'].invoke
    # Rake::Task['es:load'].invoke
  end

  task migrate_resources_tree: :environment do
    # related to https://github.com/learningtapestry/unbounded/pull/360
    # after all envs were migrated we can remove this
    puts '====> Migrate Resources Tree'
    Resource.where.not(curriculum_tree_id: nil).update_all(tree: true)
    Resource.tree.ordered.each do |res|
      res.parent_id = resource_parent(res).try(:id)
      res.save!
      print '.'
    end

    def update_curr(res)
      res.update_curriculum_tags
      res.curriculum_directory << res.short_title unless res.curriculum_directory.include?(res.short_title)
      res.save
      print '.'
      res.children.each { |c| update_curr(c) }
    end
    puts "\n====> Update Resources curriculum tags"
    Resource.tree.roots.each { |r| update_curr(r) }

    puts "\n====> Rebuild Resources hierarchies"
    Resource.rebuild!

    Rake::Task['resources:generate_positions'].invoke
    Rake::Task['es:reset'].invoke
    Rake::Task['es:load'].invoke
  end

  def resource_parent(res)
    # used on :migrate_resources_tree
    depth = Resource::HIERARCHY.index(res.curriculum_type.to_sym)
    index = depth - 1
    return if index.negative?

    type = Resource::HIERARCHY[index]
    Resource.tree.where(curriculum_type: type).where_curriculum(res.curriculum[0..index]).first
  end

  task migrate_assessments: :environment do
    puts '====> Migrate Assessments'
    Resource.tree.lessons.each do |resource|
      next unless resource.tag_list.include?('assessment')

      unit = resource.parents.detect(&:unit?)
      parent = unit.parent
      assessment_tag = resource.tag_list.include?('assessment-mid') ? 'assessment-mid' : 'assessment-end'

      # update assessment itself
      unit.append_sibling(resource)

      resource.short_title = assessment_tag
      resource.curriculum_type = :unit
      resource.curriculum_directory = parent.curriculum.push(assessment_tag)
      resource.save!

      print '.'
    end
    puts "\n"
  end
end
