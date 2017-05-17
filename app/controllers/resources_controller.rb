class ResourcesController < ApplicationController
  include CurriculumMapProps

  def show
    # redirect to lesson_document if resource has it #161
    resource, curriculum = find_resource
    return redirect_to lesson_document_path(resource.lesson_document) if resource.lesson_document?
    find_curriculum(resource, curriculum)

    # redirect grade and module to explore_curriculum
    # according to issue #122
    if @curriculum.grade? || @curriculum.module?
      return redirect_to explore_curriculum_index_path(p: @curriculum.slug.value, e: 1)
    end

    if params[:id].present? && slug = @curriculum.slug
      return redirect_to show_with_slug_path(slug.value), status: 301
    end
  end

  def related_instruction
    @resource = Resource.find params[:id]
    @instructions = find_related_instructions

    render json: {instructions: @instructions}
  end

  def media
    resource = Resource.find(params[:id])
    return redirect_to resource_path(resource) unless resource.media?
    @resource = MediaPresenter.new(resource)
    @grade_color_code = resource.grade_avg
  end

  def generic
    resource = Resource.find(params[:id])
    return redirect_to resource_path(resource) unless resource.generic?
    @resource = GenericPresenter.new(resource)
    @grade_color_code = resource.grade_avg
  end

  protected

    def find_resource
      if params[:slug].present?
        slug = ResourceSlug.find_by_value!(params[:slug])
        return slug.resource, slug.curriculum
      end
      Resource.find(params[:id])
    end

    def find_curriculum(resource, curriculum)
      curriculum ||= resource.first_tree unless params[:slug].present?

      @resource = ResourcePresenter.new(resource)
      @grade_color_code = curriculum.try(:grade_color_code)
      @curriculum = CurriculumPresenter.new(curriculum)
      @instructions = find_related_instructions

      set_index_props
    end

    def expanded?
      params[:expanded] == 'true'
    end

    def find_related_instructions
      videos = find_related_videos
      guides = find_related_guides

      instructions = []
      if expanded?
        instructions = guides + videos

      else
        if guides.size > 1  # show 2 guides
          instructions = guides[0...2]

        elsif guides.size == 1  # show 1 guide and 2 videos

          instructions = guides[0...1] + videos[0...2]

        else  # show 4 videos
          instructions = videos[0...4]

        end
      end
      @has_more = true if (videos + guides).size > instructions.size
      instructions.map { |inst|
        inst.is_a?(ContentGuide) ? InstructionSerializer.new(inst) : VideoInstructionSerializer.new(inst)
      }
    end

    def find_related_videos
      find_related_through_standards(limit: 4) do |standard|
        standard.resources.media.distinct
      end
    end

    def find_related_guides
      find_related_through_standards(limit: 2) do |standard|
        standard.content_guides
      end
    end

    def find_related_through_standards(limit:, &block)
      related = @resource.unbounded_standards.flat_map { |standard|
        qset = yield standard
        qset = qset.limit(limit) unless expanded? # limit each part
        qset
      }.uniq
      if expanded?
        related
      else
        @has_more = true if related.count > limit
        related[0...limit]  # limit total
      end
    end
end
