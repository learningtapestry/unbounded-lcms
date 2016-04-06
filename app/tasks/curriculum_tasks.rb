class CurriculumTasks
  class << self
    def generate_breadcrumbs
      Curriculum.trees.find_each { |c| c.generate_breadcrumb_pieces ; c.save! }
      Curriculum.trees.find_each { |c| c.generate_breadcrumb_titles ; c.save! }
    end
  end
end
