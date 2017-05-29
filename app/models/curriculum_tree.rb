# The CurriculumTree is a refactor on the old Curriculum.
# Here we store the whole curriculum at once into a single serialized field.
# You can also have multiple curricula, but currently we use only one.
class CurriculumTree < ActiveRecord::Base
  include Presentable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :default, uniqueness: true, if: :default

  after_save :expire_defaults_cache

  def self.default
    @default ||= where(default: true).first
  end

  def self.default_tree
    @default_tree ||= default.try(:tree)
  end

  def ela
    tree.detect { |node| node['name'] == 'ela' }
  end

  def math
    tree.detect { |node| node['name'] == 'math' }
  end

  private

  def expire_defaults_cache
    self.class.instance_variable_set :@default, nil
    self.class.instance_variable_set :@default_tree, nil
  end
end
