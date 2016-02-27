class PaginationSerializer < ActiveModel::ArraySerializer
  self.root = :results
end
