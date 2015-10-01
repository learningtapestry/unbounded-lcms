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

      have_alignment_ids = []
      highlights = []
      if params[:alignments].present?
        have_alignment_ids = LobjectAlignment
          .where(alignment_id: params[:alignments])
          .select(:lobject_id)
          .pluck(:lobject_id)
          .uniq

        keep_collection_ids = LobjectChild
          .where(child_id: have_alignment_ids)
          .select(:lobject_collection_id)
          .pluck(:lobject_collection_id)
          .uniq

        root_lobjects = root_lobjects
          .select { |l| 
            l.lobject_collections.any? { |lc| keep_collection_ids.include?(lc.id) }
          }

        params[:alignments].each do |alig|
          highlights << {
            alignment: alig,
            highlights: LobjectAlignment
              .where(:alignment_id => alig)
              .select(:lobject_id)
              .pluck(:lobject_id)
              .uniq
          } 
        end
      end

      @results = {
        highlights: highlights,
        curriculums: {
          ela: build_curriculum_hash(curriculums[:ela], root_lobjects),
          math: build_curriculum_hash(curriculums[:math], root_lobjects)
        }
      }
    end

    def build_curriculum_hash(grouped_curriculum, assorted_curriculum)
      curriculum_hash = grouped_curriculum
        .select { |c| assorted_curriculum.include?(c) }
        .map { |l| l.curriculum_map_collection.as_hash }

      curriculum_hash.each do |curriculum|
        curriculum[:description] = Lobject.find(curriculum[:id]).description
      end

      curriculum_hash
    end
  end
end
