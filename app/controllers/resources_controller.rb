class ResourcesController < ApplicationController
  def show
    find_resource_and_curriculum
    if params[:id].present? && slug = @curriculum.slug
      return redirect_to show_with_slug_path(slug.value), status: 301
    end
  end

  def related_instruction
    @resource = Resource.find params[:id]
    @related_instructions = find_related_instructions
    render json: @related_instructions.map {|ri| CurriculumResourceSerializer.new(ri)}
  end

  protected

    def find_resource_and_curriculum
      if params[:slug].present?
        slug = ResourceSlug.find_by_value!(params[:slug])
        resource = slug.resource
        curriculum = slug.curriculum
      else
        resource = Resource.find(params[:id])
        curriculum = resource.first_tree
      end

      @resource = ResourcePresenter.new(resource)
      @grade_color_code = curriculum.grade_color_code
      @curriculum = CurriculumPresenter.new(curriculum)
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
      instructions.map { |inst|
        inst.is_a?(ContentGuide) ? InstructionSerializer.new(inst) : InstructionVideoSerializer.new(inst)
      }
    end

    def find_related_videos
      related = @resource.standards.flat_map { |st|
        qset = st.resources.where(resource_type: accepted_resource_types)
        qset = qset.limit(4) unless expanded?  # limit each part
        qset
      }.uniq
      expanded? ? related : related[0...4]  # limit total
    end

    def find_related_guides
      related = @resource.standards.flat_map { |st|
        qset = st.content_guides
        qset = qset.limit(2) unless expanded? # limit each part
        qset
      }.uniq
      expanded? ? related : related[0...2]  # limit total
    end

    def accepted_resource_types
      [
        Resource.resource_types[:video],
        Resource.resource_types[:podcast]
      ]
    end
end
