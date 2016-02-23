class LessonSerializer < ActiveModel::Serializer
  self.root = false
  
  attributes :id, :title, :description
end
