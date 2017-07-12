# The CurriculumTree is a refactor on the old Curriculum.
# Here we store the whole curriculum at once into a single serialized field.
# You can also have multiple curricula, but currently we use only one.
class CurriculumTree < ActiveRecord::Base
  SUBJECTS = %w(ela math lead).freeze
  HIERARCHY = %i(subject grade module unit lesson).freeze

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :default, uniqueness: true, if: :default

  after_save :expire_defaults_cache

  def self.default
    @default ||= where(default: true).first
  end

  def self.default_tree
    @default_tree ||= default.try(:tree)
  end

  def self.next_level(rtype)
    type = rtype.is_a?(Resource) ? rtype.curriculum_type : rtype
    index = HIERARCHY.index(type.to_sym)
    HIERARCHY[index + 1] if index
  end

  def ela
    tree.detect { |node| node['name'] == 'ela' }
  end

  def math
    tree.detect { |node| node['name'] == 'math' }
  end

  def self.positions_index
    @pos_index || build_positions_index
  end

  def self.build_positions_index
    @pos_index = {}
    default_tree.each_with_index { |node, index| node_index(node, index, [], []) }
    max_size = @pos_index.values.map(&:size).max
    @pos_index.each do |key, vals|
      (max_size - vals.size).times { vals << 0 }
      @pos_index[key] = vals
    end
  end

  def self.node_index(node, index, names, pos)
    names << node['name']
    pos << index + 1
    @pos_index[names.join('|')] = pos
    node['children'].each_with_index { |n, i| node_index(n, i, names.dup, pos.dup) }
  end

  def self.insert_branch_for(resource)
    return unless default

    level = default.tree
    new_entries = []
    resource.curriculum.each_with_index do |tag, index|
      node = level.detect { |n| n['name'] == tag }
      unless node
        node = { 'name' => tag, 'children' => [] }
        level << node
        new_entries << resource.curriculum[0..index]
      end
      level = node['children']
    end
    return if new_entries.empty?

    ActiveRecord::Base.transaction do
      new_entries.each { |curr| Resource.create_from_curriculum(curr) if curr != resource.curriculum }
      default.update_columns(tree: default.tree)
      @default_tree = default.tree
      @pos_index = nil
    end
  end

  private

  def expire_defaults_cache
    self.class.instance_variable_set :@default, nil
    self.class.instance_variable_set :@default_tree, nil
    self.class.instance_variable_set :@pos_index, nil
  end
end
