class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :short_title, :img, :path
end
