class GoogleDocsController < ApplicationController
  def show
    @google_doc = GoogleDocPresenter.new(GoogleDoc.find(params[:id]))
  end
end
