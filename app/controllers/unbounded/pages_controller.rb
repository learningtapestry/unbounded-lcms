module Unbounded
  class PagesController < UnboundedController
    def show
      @page = Page.find(params[:id])
    end

    def show_slug
      slug = params[:slug].to_s
      @page = Page.find_by(slug: slug)
      render slug if template_exists?(slug, 'unbounded/pages')
    end
  end
end
