module Filterbar
  extend ActiveSupport::Concern

  included do
    def grade_params
      names = split_params(params[:g]) & [
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
      split_params(params[:s]) & ['ela', 'math']
    end

    def facets_params
      split_params(params[:f]) & [
        'curriculum', 'instructions'
      ]
    end

    def search_term
      params[:search_term]
    end


    def filterbar_props
      {
        filterbar: {
          subjects: subject_params,
          grades: grade_params,
          facets: facets_params,
          search_term: search_term
        }
      }
    end

    protected

    def split_params(p)
      return [] if p.blank?
      p.gsub!(/\s+/, '')
      p.split(',')
    end
  end
end
