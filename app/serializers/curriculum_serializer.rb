class CurriculumSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper
  
  self.root = false

  attributes :id,
    :resource_id,
    :children,
    :title,
    :description,
    :estimated_time,
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

  def description
    truncate_html(object.resource.description, length: 200)
  end

  def estimated_time
    40
  end

  def expanded
    true
  end

  def resource_id
    object.resource.id
  end

  def title
    object.resource.title
  end

  def type
    object.curriculum_type.name
  end

end
