class SearchDocumentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :model_id, :model_type, :title, :path, :type_name, :teaser

  def path
    model_type == 'content_guide' ? content_guide_path(object.model_id) : resource_path(object.model_id)
  end

  def type_name
    model_type == 'content_guide' ? 'Content Guide' : '? Resource ?'
  end

end
