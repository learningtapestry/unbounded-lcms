class EnhanceInstructionController < ApplicationController
  def index
    @props = EnhanceInstructionInteractor.call(self).props
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end
end
