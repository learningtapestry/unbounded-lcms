class ContentGuidesController < ApplicationController
  include AnalyticsTracking

  before_action :find_content_guide

  def show; end

  def show_pdf
    return render(interactor.pdf_params) if interactor.debug?

    cg = interactor.content_guide
    ga_track_download(action: content_guide_path(cg.permalink_or_id, cg.slug), label: '')

    cg.pdf_refresh!(url_for(nocache: ''))
    redirect_to cg.pdf_url
  end

  protected

  def find_content_guide
    @content_guide = interactor.presenter
  end

  def interactor
    ContentGuidesInteractor.call(self)
  end
end
