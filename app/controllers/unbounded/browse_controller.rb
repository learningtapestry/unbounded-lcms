require 'content/models'

module Unbounded
  class BrowseController < UnboundedController
    layout "unbounded_new", only: [:home, :search, :search_new, :show_new]

    def index
      @search = LobjectFacets.new(params)
    end

    def search
      @search = LobjectSearch.new(params)
    end

    def show
      @lobject = LobjectPresenter.new(Content::Models::Lobject.find(params[:id]))
    end

    def home
    end

    def search_new
    end

    def show_new
      @lobject = LobjectPresenter.new(Content::Models::Lobject.find(params[:id]))
    end

    def search_curriculum
      [:grade, :alignments, :curriculum].each do |f| 
        params.delete(f) if params[f] == 'all'
      end

      search = CurriculumSearch.new(params)
      render json: {
        curriculums: search.results,
        dropdown_options: build_dropdown_options
      }
    end

    def resource_preview
      render json: Lobject.find(params[:id]), serializer: LobjectPreviewSerializer
    end

    protected

    def build_dropdown_options
      alignments = Alignment.by_organization(Organization.unbounded)

      grades_9_12 = (9..12).map { |i| Grade.find_by(grade: "grade #{i}") }

      if params[:grade].present?
        alignments = alignments.by_grade(Grade.find(params[:grade].to_i))
      else
        alignments = alignments.by_grades(grades_9_12)
      end

      if params[:curriculum].present?
        alignments = alignments.by_curriculum(params[:curriculum].to_sym)
      end

      all_option = { text: 'All', value: :all }

      curriculums = [
        all_option,
        { text: t('unbounded.curriculum.ela'), value: :ela },
        { text: t('unbounded.curriculum.math'), value: :math },
      ]

      alignments = [all_option] + alignments.uniq.map { |a| { text: a.name, value: a.id } }
      grades = [all_option] + grades_9_12.map { |g| { text: g.grade, value: g.id } }

      { alignment: alignments, curriculum: curriculums, grade: grades }
    end
  end
end
