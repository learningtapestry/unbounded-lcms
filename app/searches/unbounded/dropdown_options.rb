module Unbounded
  class DropdownOptions
    include Content::Models

    attr_reader :dropdown_options

    def initialize(params)
      alignments = Alignment.select(:id, :name).by_organization(Organization.unbounded)

      grades_9_12 = (9..12).map { |i| Grade.find_by(grade: "grade #{i}") }

      if params[:grade].present?
        alignments = alignments.by_grade(Grade.find(params[:grade].to_i))
      else
        alignments = alignments.by_grades(grades_9_12)
      end

      if params[:curriculum].present?
        alignments = alignments.by_collections(LobjectCollection.curriculum_maps_for(params[:curriculum]))
      else
        alignments = alignments.by_collections(LobjectCollection.curriculum_maps)
      end

      all_option = { text: 'All', value: :all }

      curriculums = [
        all_option,
        { text: I18n.t('unbounded.curriculum.ela'), value: :ela },
        { text: I18n.t('unbounded.curriculum.math'), value: :math },
      ]

      alignments = [all_option] + alignments.uniq.map { |a| { text: a.name, value: a.id } }
      grades = [all_option] + grades_9_12.map { |g| { text: g.grade, value: g.id } }

      @dropdown_options = { 
        alignment: alignments, 
        curriculum: curriculums, 
        grade: grades 
      }
    end
  end
end
