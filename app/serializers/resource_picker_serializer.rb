class ResourcePickerSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title
end
