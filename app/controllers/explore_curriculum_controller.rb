class ExploreCurriculumController < ApplicationController
  include Filterbar

  def index
    set_index_props

    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  def show
    set_show_props

    respond_to do |format|
      format.json { render json: @props }
    end
  end

  protected

    def set_curriculums
      @curriculums = Curriculum.trees
        .grades
        .with_resources
        .where_subject(subject_params)
        .where_grade(grade_params)
        .order('resources.subject', :position)
    end

    def set_index_props
      set_curriculums

      @props = begin
        if slug_param
          target_curriculum = ResourceSlug.find_by!(value: slug_param).curriculum
          raise StandardError unless target_curriculum

          parent_curriculum = target_curriculum
          while parent_curriculum.current_level != :grade
            parent_curriculum = parent_curriculum.parent
          end

          hrchy = [:grade, :module, :unit]
          depth = hrchy.find_index(target_curriculum.current_level) + 1
          active_branch = target_curriculum.self_and_ancestor_ids.reverse[1..-1]
          expanded = params[:e].present?
          if expanded
            depth += 1

            if target_curriculum.children.size > 0
              active_branch << target_curriculum.children.first.id
            end
          end

          props = {
            active: active_branch,
            results: @curriculums.map do |c|
              CurriculumSerializer.new(c,
                depth: c.id == parent_curriculum.id ? depth : 0,
                depth_branch: active_branch
              ).as_json
            end
          }
          props[:expanded] = true if expanded
          props.merge!(filterbar_props)
        else
          ActiveModel::ArraySerializer.new(@curriculums,
            each_serializer: CurriculumSerializer,
            root: :results
          ).as_json.merge!(filterbar_props)
        end
      end
    end

    def set_show_props
      @curriculum = Curriculum.find(params[:id])
      @props = CurriculumSerializer.new(@curriculum, depth: 1).as_json
    end

    def slug_param
      if (slug = params[:p]).present?
        if slug.start_with?('/')
          slug[1..-1]
        else
          slug
        end
      end
    end

end
