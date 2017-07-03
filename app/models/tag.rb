class Tag < ActsAsTaggableOn::Tag
  scope :where_context, ->(context) { joins(:taggings).where(taggings: { context: context }) }
end
