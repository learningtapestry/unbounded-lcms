module Filterbar
  extend ActiveSupport::Concern

  included do
    def grade_params
      Array.wrap(params[:grades]) & [
        'pk', 'k', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
      ]
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
