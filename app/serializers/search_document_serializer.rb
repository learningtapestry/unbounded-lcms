class SearchDocumentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :model_id, :model_type, :title, :path, :type_name, :teaser

  def id
    object.model_id
  end

  def path
    "#"
  end

  def type_name
    model_type == 'content_guide' ? 'Content Guide' : '? Resource ?'
  end

end
