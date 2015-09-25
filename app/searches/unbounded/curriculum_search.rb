require 'content/models'
require 'content/search'

module Unbounded
  class CurriculumSearch
    include Content::Models

    attr_reader :results

    def initialize(params = {})
      curriculums = Lobject.find_curriculums

      if params[:curriculum].present?
        root_lobjects = curriculums[params[:curriculum].to_sym]
      else
        root_lobjects = curriculums[:math] + curriculums[:ela]
      end

      if params[:grade].present?
        only_grades = [Grade.find(params[:grade].to_i  )]
      else
        only_grades = (9..12).map { |i| Grade.find_by(grade: "grade #{i}") }
      end
      root_lobjects = root_lobjects
        .select { |l| l.grades.any? { |g| only_grades.include?(g) } }

      collection_ids = root_lobjects.map { |l| l.curriculum_map_collection.id }

      have_alignment_ids = []
      if params[:alignments].present?
        all_lobject_ids = LobjectChild
          .where(lobject_collection_id: collection_ids)
          .pluck(:child_id)
          .uniq

        have_alignment_ids = LobjectAlignment
          .joins(:alignment)
          .where('alignments.id' => params[:alignments].map(&:to_i))
          .where(lobject_id: all_lobject_ids)
          .pluck(:lobject_id)
          .uniq

        keep_collection_ids = LobjectChild
          .where(child_id: have_alignment_ids)
          .pluck(:lobject_collection_id)
          .uniq

        root_lobjects = root_lobjects
          .select { |l| 
            l.lobject_collections.any? { |lc| keep_collection_ids.include?(lc.id) }
          }
      end

      @results = {
        highlights: have_alignment_ids,
        curriculums: {
          ela: build_curriculum_hash(curriculums[:ela], root_lobjects),
          math: build_curriculum_hash(curriculums[:math], root_lobjects)
        }
      }
    end

    def build_curriculum_hash(grouped_curriculum, assorted_curriculum)
      grouped_curriculum
      .select { |c| assorted_curriculum.include?(c) }
      .map { |l| l.curriculum_map_collection.as_hash }
    end
  end
end
