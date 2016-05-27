class SearchCurriculumResourceSerializer < CurriculumResourceSerializer

  def initialize(obj, opts={})
    super
    self.object = Curriculum.trees.with_resources.find_by(item_id: self.object.model_id)
  end

end
