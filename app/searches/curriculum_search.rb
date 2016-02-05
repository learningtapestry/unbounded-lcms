class CurriculumSearch
  attr_reader :params, :results

  def initialize(params = {})
    @params = params
  end

  def curriculums
    @curriculums ||= Resource.find_curriculums
  end

  def root_resources
    unless defined? @root_resources
      if params[:subject].present? && params[:subject] != 'all'
        @root_resources = curriculums[params[:subject].to_sym]
      else
        @root_resources = curriculums[:math] + curriculums[:ela]
      end

      if params[:grade].present?
        only_grades = [Grade.find_by(name: params[:grade] )]
      else
        only_grades = (9..12).map { |i| Grade.find_by(grade: "grade #{i}") }
      end

      @root_resources = @root_resources
        .select { |l| l.grades.any? { |g| only_grades.include?(g) } }
    end
    
    @root_resources
  end

  def curriculum_roots
    {
      ela: build_curriculum_hash(curriculums[:ela], root_resources),
      math: build_curriculum_hash(curriculums[:math], root_resources)
    }
  end

  def highlights
    return [] unless params[:standards].present?
    
    highlights = params[:standards].map do |alig|
      {
        alignment: { id: alig.to_i, name: Alignment.find(alig).name },
        highlights: ResourceAlignment
          .where(:alignment_id => alig)
          .select(:resource_id)
          .pluck(:resource_id)
          .uniq
      } 
    end

    highlights
  end

  def build_curriculum_hash(grouped_curriculum, assorted_curriculum)
    curriculum_hash = grouped_curriculum
      .select { |c| assorted_curriculum.include?(c) }
      .map { |l| l.curriculum_map_collection.tree }

    curriculum_hash
  end
end
