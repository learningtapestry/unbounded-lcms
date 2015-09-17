module Unbounded
  module Admin
    class LobjectBulkEditsController < AdminController
      before_action :load_resources

      def new
        if @lobjects.any?
          @lobject = Lobject.init_for_bulk_edit(@lobjects)
        else
          redirect_to :unbounded_admin_lobjects, alert: t('.no_resources')
        end
      end

      def create
        lobject_params = params.require(:content_models_lobject).permit(alignment_ids: [], grade_ids: [], resource_type_ids: [])
        sample = Lobject.new(lobject_params)
        Lobject.bulk_edit(sample, @lobjects)
        redirect_to :unbounded_admin_lobjects, notice: t('.success', count: @lobjects.count, resources_count: t(:resources_count, count: @lobjects.count))
      end

      private
        def load_resources
          @lobjects = Lobject.where(id: params[:ids]).includes(:alignments, :grades, :resource_types)
        end
    end
  end
end
