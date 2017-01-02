module GradeListHelper
  extend ActiveSupport::Concern
  GRADES = ['prekindergarten', 'kindergarten', 'grade 1', 'grade 2', 'grade 3',
            'grade 4', 'grade 5', 'grade 6', 'grade 7', 'grade 8', 'grade 9',
            'grade 10', 'grade 11', 'grade 12'].freeze

  included do
    def grade_avg
      grade_abbr(GRADES[grade_avg_num]) || 'base'
    end

    def grade_avg_num
      grade_list_f = grade_list & GRADES
      grade_list_f.map { |g| GRADES.index(g) }
                  .sum / grade_list_f.size
    end

    def grade_color_code
      grade_list.map { |g| grade_abbr(g) }
                .compact
                .try(:first) || 'base'
    end

    def color_code(g = 'base')
      subject_color_code = try(:subject) || 'default'
      "#{subject_color_code}-#{g}"
    end

    protected

    def grade_abbr(g)
      grade = g.downcase
      return 'k' if grade == 'kindergarten'
      return 'pk' if grade == 'prekindergarten'
      grade[/\d+/] if grade[/\d+/]
    end
  end
end
