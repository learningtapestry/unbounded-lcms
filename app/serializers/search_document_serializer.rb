class SearchDocumentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :model_id, :model_type, :title, :path, :type_name, :teaser, :breadcrumbs, :subject, :grade

  def path
    if model_type == 'content_guide'
      content_guide_path(object.model_id)
    else
      if ['podcast', 'video'].include?(object.doc_type)
        media_path(object.model_id)
      else
        resource_path(object.model_id)
      end
    end
  end

  def type_name
    object.doc_type.titleize
  end

  def grade
    (model_type == 'content_guide' || media_resource?) ? 'base' : grade_color_code
  end

  private
  def grade_color_code
    object.grade.each do |g|
      grade = g.downcase
      return 'k' if grade == 'kindergarten'
      return 'pk' if grade == 'prekindergarten'
      return grade[/\d+/] if grade[/\d+/]
    end
    'base'
  end

  def media_resource?
    object.doc_type == 'video' || object.doc_type == 'podcast'
  end

end
