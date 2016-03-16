module Admin
  class ContentGuideStandardsController < AdminController
    def index
      @standards = ContentGuideStandard.order(:statement_notation, :alt_statement_notation)
    end
  end
end
