# frozen_string_literal: true

namespace :resources do
  desc 'Fixes formatting for resources'
  task fix_formatting: [:environment] { ResourceTasks.fix_formatting }

  desc 'Fix lessons metadata'
  task fix_lessons_metadata: [:environment] { ResourceTasks.fix_lessons_metadata }

  desc 'Generate hierarchical positions for resources'
  task generate_positions: [:environment] { GenerateHierarchicalPositions.new.generate! }

  desc 'Generate slugs'
  task generate_slugs: [:environment] { Slug.generate_resources_slugs }

  desc 'Updates time to teach resources'
  task update_time_to_teach: [:environment] { ResourceTasks.update_time_to_teach }

  desc 'Sync reading assignment'
  task sync_reading_assignments: [:environment] { ResourceTasks.sync_reading_assignments }

  desc 'Load curriculum directory data'
  task curriculum_directories: :environment do
    require_relative '../../db/data/curriculum_directory_migrator'
    CurriculumDirectoryMigrator.new.migrate!
  end

  desc 'Export to CSV' # Usage: $ bin/rake resources:export[tmp/resources.csv]
  task :export, [:filename] => [:environment] do |task, args|
    # TODO: check whether its deprecated

    filename = args[:filename]
    if filename.blank?
      puts('No filename given')
      next
    end

    data = ActiveRecord::Base.connection.execute <<-SQL
      SELECT
        resources.title,
        resources.description,
        STRING_AGG(DISTINCT grades.name, ';') AS grades,
        resources.subject,
        STRING_AGG(DISTINCT topics.name, ';') AS topics,
        STRING_AGG(DISTINCT authors.name, ';') AS authors,
        STRING_AGG(DISTINCT standards.name, ';') AS standards,
        STRING_AGG(DISTINCT keywords.name, ';') AS keywords,
        resources.time_to_teach,
        modules.title AS collection_title,
        modules.description AS collection_description,
        COALESCE(collections.position, 0) + 1 AS collection_order,
        CASE
          WHEN BTRIM(COALESCE(slugs.value, '')) = '' THEN NULL
          ELSE 'https://unbounded.org/' || slugs.value END AS url
      FROM curriculum_types
        INNER JOIN curriculums ON
          curriculum_types.id = curriculums.curriculum_type_id AND
          curriculum_types.name = 'unit'
          INNER JOIN curriculums AS collections ON
            curriculums.parent_id = collections.id
            INNER JOIN resources AS modules ON
              collections.item_type = 'Resource' AND
              collections.item_id = modules.id
          INNER JOIN resources ON
            curriculums.item_type = 'Resource' AND
            curriculums.item_id = resources.id
            LEFT JOIN resource_slugs AS slugs ON
              curriculums.id = slugs.curriculum_id AND
              resources.id = slugs.resource_id
            LEFT JOIN resource_reading_assignments AS assignments ON
              resources.id = assignments.resource_id
              LEFT JOIN reading_assignment_texts AS texts ON
                assignments.reading_assignment_text_id = texts.id
                LEFT JOIN reading_assignment_authors AS authors ON
                  texts.reading_assignment_author_id = authors.id
            LEFT JOIN taggings AS taggings_grades ON
              taggings_grades.context = 'grades' AND
              taggings_grades.taggable_type = 'Resource' AND
              taggings_grades.taggable_id = resources.id
              LEFT JOIN tags AS grades ON
                grades.id = taggings_grades.tag_id
            LEFT JOIN taggings AS taggings_topics ON
              taggings_topics.context = 'topics' AND
              taggings_topics.taggable_type = 'Resource' AND
              taggings_topics.taggable_id = resources.id
              LEFT JOIN tags AS topics ON
                topics.id = taggings_topics.tag_id
            LEFT JOIN taggings AS taggings_keywords ON
              taggings_keywords.context = 'tags' AND
              taggings_keywords.taggable_type = 'Resource' AND
              taggings_keywords.taggable_id = resources.id
              LEFT JOIN tags AS keywords ON
                keywords.id = taggings_keywords.tag_id
            LEFT JOIN resource_standards ON
              resource_standards.resource_id = resources.id
              LEFT JOIN standards ON
                standards.id = resource_standards.standard_id
      GROUP BY
        resources.title,
        resources.description,
        resources.subject,
        resources.time_to_teach,
        modules.title,
        modules.description,
        collections.position,
        slugs.value
    SQL

    fields = data.fields

    CSV.open(filename, 'wb') do |csv|
      csv << fields
      data.each { |row| csv << row.values_at(*fields) }
    end

    puts("Resources data exported to #{filename}")
  end
end
