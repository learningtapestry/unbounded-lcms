module Filterbar
  extend ActiveSupport::Concern

  included do
    def grade_params
      names = Array.wrap(params[:grades]) & [
        'pk', 'k', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
      ]

      names.map! do |name|
        name = name.to_s
        if name.upcase == 'K'
          name = 'kindergarten'
        elsif name.upcase == 'PK'
          name = 'prekindergarten'
        elsif !name.start_with?('grade')
          name = "grade #{name}"
        end
        name
      end

      names
    end

    def subject_params
      Array.wrap(params[:subjects]) & ['ela', 'math']
    end

    def filterbar_props
      {
        filterbar: {
          subjects: subject_params,
          grades: grade_params
        }
      }
    end
  end
end
