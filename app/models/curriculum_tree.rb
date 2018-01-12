# TODO: The CurriculumTree was a refactor on the old Curriculum. But now its deprecated too,
# a little while after we deploy the code with the resources tree we should remove this
class CurriculumTree < ActiveRecord::Base
  def self.default
    @default ||= where(default: true).first
  end

  def self.default_tree
    @default_tree ||= default.try(:tree)
  end
end
