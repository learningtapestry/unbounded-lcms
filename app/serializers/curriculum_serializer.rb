class CurriculumSerializer < ActiveModel::Serializer  
  self.root = false

  attributes :id,
    :resource,
    :children,
    :type

  def initialize(object, options = {})
    super(object, options)
    @depth = options[:depth] || 0
  end

  def children
    if @depth > 0
      kids = if object.item_is_curriculum?
        object.curriculum_item.children
      else
        object.children
      end

      kids.map { |c| CurriculumSerializer.new(c, depth: @depth - 1).as_json }
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
    include ResourceHelper

    self.root = false
    attributes :id, :title, :short_title, :description, :estimated_time, :path

    def description
      truncate_html(object.description, length: 200)
    end

    def estimated_time
      40
    end

    def path
      show_resource_path(object)
    end
  end
end
