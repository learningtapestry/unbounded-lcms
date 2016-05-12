class SearchDocumentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :model_id, :model_type, :title, :path, :type_name, :teaser, :breadcrumbs

  def path
    model_type == 'content_guide' ? content_guide_path(object.model_id) : resource_path(object.model_id)
  end

  def type_name
    object.breadcrumbs || object.doc_type.titleize
  end

end
