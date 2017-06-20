module Filterbar
  extend ActiveSupport::Concern

  included do
    def untranslated_grade_params
      split_params(params[:grades]) & %w(pk k 1 2 3 4 5 6 7 8 9 10 11 12)
    end

    def grade_params
      untranslated_grade_params.map do |name|
        if name.casecmp('k').zero?
          'kindergarten'
        elsif name.casecmp('pk').zero?
          'prekindergarten'
        elsif !name.start_with?('grade')
          "grade #{name}"
        end
      end
    end

    def subject_params
      split_params(params[:subjects]) & %w(ela math lead)
    end

    def facets_params
      split_params(params[:facets]) & %w(grade module unit lesson content_guide multimedia other)
    end

    def search_term
      params[:search_term]
    end

    def search_params
      options = pagination_params.slice(:page, :per_page)

      # handle filters
      options[:doc_type] = search_facets_params if facets_params.present?
      options[:subject] = subject_params.first if subject_params.present?
      options[:grade] = grade_params if grade_params.present?

      options
    end

    def search_facets_params
      search_facets = facets_params
      search_facets.push('video', 'podcast') if search_facets.delete('multimedia')
      search_facets.push('text_set', 'quick_reference_guide') if search_facets.delete('other')
      search_facets
    end

    def filterbar_props
      {
        filterbar: {
          subjects: subject_params,
          grades: untranslated_grade_params,
          facets: facets_params,
          search_term: search_term
        }
      }
    end

    protected

    def split_params(p)
      return [] if p.blank?
      return p if p.kind_of?(Array)

      p.gsub!(/\s+/, '')
      p.split(',')
    end
  end
end
