class GoogleDocsController < ApplicationController
  def show
    @google_doc = GoogleDocPresenter.new(GoogleDoc.find(params[:id]), request.base_url, view_context)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @google_doc.name,
               disposition: 'attachment',
               margin: {
                 top: 15
               },
               header: {
                 left: @google_doc.name,
                 spacing: 5
               },
               footer: {
                 right: '[page]'
               }
      end
    end
  end
end
