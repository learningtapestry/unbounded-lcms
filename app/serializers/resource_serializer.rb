class ResourceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :description, :short_title, :subtitle
end
