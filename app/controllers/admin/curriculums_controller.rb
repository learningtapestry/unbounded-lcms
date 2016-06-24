class Admin::CurriculumsController < Admin::AdminController

  include Admin::CurriculumsHelper

  class ConciseCurriculumSerializer < CurriculumSerializer
    def initialize(object, options = {})
      options[:depth] = 1
      options[:counts] = false
      super(object, options)
    end
  end

  include Pagination

  def index
    @curriculums = Curriculum.seeds
      .with_resources
      .where_subject(index_params[:subject])
      .where_grade(param_constants[:grades][index_params[:grade]])
      .where(curriculum_type: param_constants[:curriculum_types][index_params[:type]])
      .where(parent_id: nil)
      .paginate(pagination_params.slice(:page, :per_page))
      .order("resources.title #{pagination_params[:order].to_s}")

    @index_params = index_params
  end

  def new
    @curriculum = Curriculum.new
  end

  def edit
    find_curriculum
  end

  def create
    build_curriculum
    redirect_to [:edit, :admin, @curriculum]
  end

  def update
    build_curriculum
    redirect_to [:edit, :admin, @curriculum]
  end

  protected
    def index_params
      @index_params ||= begin
        default_params = { type: 'grade', subject: 'ela', grade: nil }
        expected_params = params.slice(:type, :subject, :grade).symbolize_keys
        index_p = default_params.merge(expected_params)

        subjects = ['ela', 'math']
        
        grade_ok = index_p[:grade].blank? || 
          param_constants[:grades].keys.include?(index_p[:grade])
        type_ok = param_constants[:curriculum_types].keys.include?(index_p[:type])
        subject_ok = subjects.include?(index_p[:subject])

        raise StandardError unless grade_ok && type_ok && subject_ok

        index_p
      end
    end

    def find_curriculum
      @curriculum = Curriculum.seeds.find(params[:id])
    end

    def curriculum_params
      params
        .require(:curriculum)
        .permit(:curriculum_type_id, :item_id, child_ids: [])
    end

    def build_curriculum
      p = curriculum_params
      Curriculum.transaction do
        new_children_ids = p.delete(:child_ids).map(&:to_i)
        new_children = Curriculum.where(id: new_children_ids)

        @curriculum = if params[:id].present?
                        Curriculum.find(params[:id])
                      else
                        c = Curriculum.new(p)
                        c.item_type = 'Resource'
                        c.save!
                        c.update_generated_fields
                        c
                      end

        current_item_ids = @curriculum.children.pluck(:item_id)

        @curriculum.children.each do |current_child|
          unless new_children_ids.include?(current_child.item_id)
            current_child.destroy!
          end
        end

        new_children.each do |curriculum|
          new_position = new_children_ids.index(curriculum.id)
          if current_item_ids.include?(curriculum.id)
            @curriculum.children
              .find_by(item_id: curriculum.id)
              .update_columns(position: new_position)
          else
            @curriculum.children.create!(
              item_id: curriculum.id,
              item_type: 'Curriculum',
              curriculum_type: curriculum.curriculum_type,
              position: new_position
            )
          end
        end

        new_children.each { |curriculum| curriculum.update_generated_fields }

        @curriculum.update_attributes!(p)
        @curriculum.reload
        @curriculum.update_trees
      end
    end
end
