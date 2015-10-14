module Unbounded
  class DropdownOptions
    include ActiveModel::Model
    include Content::Models

    attr_accessor :subject, :grade_id, :standard_ids

    def standards
      unless defined? @standards
        alignments = Alignment.select(:id, :name).by_organization(Organization.unbounded)

        if grade_id
          alignments = alignments.by_grade(Grade.find(grade_id))
        else
          alignments = alignments.by_grades(grades)
        end

        if subject
          alignments = alignments.by_collections(LobjectCollection.curriculum_maps_for(subject))
        else
          alignments = alignments.by_collections(LobjectCollection.curriculum_maps)
        end

        @standards = alignments.uniq
      end

      @standards
    end

    def standard_options
      [all_option] + standards.map { |s| [s.name, s.id] }
    end

    def subject_options
      [
        struct(
          title: I18n.t('unbounded.curriculum.ela'),
          value: 'ela',
          checked: subject == 'ela'
        ),
        struct(
          title: I18n.t('unbounded.curriculum.math'),
          value: 'math',
          checked: subject == 'math'
        )
      ]
    end

    def grades
      (9..12).map { |i| Grade.find_by(grade: "grade #{i}") }
    end

    def grade_options
      grades.map do |g|
        struct(
          title: grade_name(g.grade),
          value: g.id,
          grade: g.grade,
          checked: grade_id == g.id
        )
      end
    end

    def grade_name(grade)
      grade_subject = subject || 'ela'
      I18n.t("unbounded.grades.#{grade_subject}.#{grade.strip.gsub(' ', '_')}")
    end

    def all_option
      [I18n.t('ui.all'), 'all']
    end

    def struct(hash)
      OpenStruct.new(hash)
    end
  end
end
