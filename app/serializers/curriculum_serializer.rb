class CurriculumSerializer < ActiveModel::Serializer  
  self.root = false

  attributes :id,
    :resource,
    :children,
    :type

  def initialize(object, options = {})
    super(object, options)
    @with_children = !!options[:with_children]
  end

  def children
    if @with_children
      kids = if object.item_is_curriculum?
        object.curriculum_item.children
      else
        object.children
      end

      kids.map { |c| CurriculumSerializer.new(c).as_json }
    else
      []
    end
  end

  def resource
    self.class::ResourceSerializer.new(object.resource).as_json
  end

  def type
    object.curriculum_type.name
  end

  class ResourceSerializer < ActiveModel::Serializer
    include TruncateHtmlHelper

    self.root = false
    attributes :id, :title, :description, :estimated_time

    def description
      truncate_html(object.description, length: 200)
    end

    def estimated_time
      40
    end
  end
end
