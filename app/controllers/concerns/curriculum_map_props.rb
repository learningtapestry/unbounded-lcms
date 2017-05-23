module CurriculumMapProps
  extend ActiveSupport::Concern

  included do
    # TODO: Need to eliminate N+1 queries here
    def set_index_props
      return @props = {} unless @curriculum.present?
      full_depth = @curriculum.unit? || @curriculum.lesson? || @curriculum.module?
      active_branch = @curriculum.self_and_ancestor_ids
      target_branch = full_depth ? @curriculum.current_module.child_ids : []
      curriculum = CurriculumSerializer.new(
        @curriculum.current_grade,
        depth: full_depth ? @curriculum.hierarchy.size : 1,
        depth_branch: active_branch + target_branch
      ).as_json
      @props = {
        active: active_branch,
        results: curriculum
      }
    end
  end
end
