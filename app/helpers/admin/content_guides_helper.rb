module Admin::ContentGuidesHelper
  def content_guide_nav(cg)
    Rails.cache.fetch("content_guides:#{cg.id}:nav") { render partial: 'nav', locals: { cg: cg } }
  end
end
