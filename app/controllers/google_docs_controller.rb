class GoogleDocsController < ApplicationController
  def show
    google_doc = GoogleDoc.find(params[:id])

    respond_to do |format|
      format.html do
        @google_doc = GoogleDocPresenter.new(google_doc, request.base_url, view_context)
      end

      format.pdf do
        @google_doc = GoogleDocPdfPresenter.new(google_doc, request.base_url, view_context)

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
