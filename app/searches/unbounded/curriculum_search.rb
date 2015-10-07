require 'content/models'
require 'content/search'

module Unbounded
  class CurriculumSearch
    include Content::Models

    attr_reader :params, :results

    def initialize(params = {})
      @params = params
    end

    def curriculums
      @curriculums ||= Lobject.find_curriculums
    end

    def root_lobjects
      unless defined? @root_lobjects
        if params[:subject].present? && params[:subject] != 'all'
          @root_lobjects = curriculums[params[:subject].to_sym]
        else
          @root_lobjects = curriculums[:math] + curriculums[:ela]
        end

        if params[:grade].present?
          only_grades = [Grade.find_by(name: params[:grade] )]
        else
          only_grades = (9..12).map { |i| Grade.find_by(grade: "grade #{i}") }
        end

        @root_lobjects = @root_lobjects
          .select { |l| l.grades.any? { |g| only_grades.include?(g) } }
      end
      
      @root_lobjects
    end

    def curriculum_roots
      {
        ela: build_curriculum_hash(curriculums[:ela], root_lobjects),
        math: build_curriculum_hash(curriculums[:math], root_lobjects)
      }
    end

    def highlights
      return [] unless params[:standards].present?
      
      highlights = params[:standards].map do |alig|
        {
          alignment: { id: alig.to_i, name: Alignment.find(alig).name },
          highlights: LobjectAlignment
            .where(:alignment_id => alig)
            .select(:lobject_id)
            .pluck(:lobject_id)
            .uniq
        } 
      end

      highlights
    end

    def build_curriculum_hash(grouped_curriculum, assorted_curriculum)
      curriculum_hash = grouped_curriculum
        .select { |c| assorted_curriculum.include?(c) }
        .map { |l| l.curriculum_map_collection.tree }

      curriculum_hash
    end
  end
end
