module CurriculumMapProps
  extend ActiveSupport::Concern

  included do
    def set_index_props
      return @props = {} unless @curriculum.present?
      full_depth = @curriculum.unit? || @curriculum.lesson? || @curriculum.module?
      active_branch = @curriculum.self_and_ancestor_ids
      target_branch = full_depth ? @curriculum.current_module.child_ids : []
      @props = { active: active_branch,
                 results:
                    CurriculumSerializer.new(@curriculum.current_grade,
                                             depth: full_depth ? @curriculum.hierarchy.size : 1,
                                             depth_branch: active_branch + target_branch
                                             ).as_json
                }
    end
  end
end
