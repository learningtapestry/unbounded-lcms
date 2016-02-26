class PaginationSerializer < ActiveModel::ArraySerializer
  self.root = 'data'

  def initialize(object, options = {})
    meta_key = options[:meta_key] || :meta
    options[meta_key] ||= {}
    options[meta_key] = {
      total_pages: object.total_pages,
      current_page: object.current_page,
      show_by: object.per_page,
      sort_by: options[:sort_by],
      total_hits: object.total_entries
    }
    super(object, options)
  end
end
