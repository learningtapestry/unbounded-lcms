# Handle the form data from the CurriculumTreeEditor admin component
class CurriculumTreeForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, Integer, presence: true
  attribute :tree, Array[Hash], presence: true
  attribute :change_log, Array[Hash]

  def initialize(id, params = nil)
    params ||= {}
    attrs = parse_attrs(params).merge(id: id)
    super(attrs)
  end

  def save
    return false unless valid?

    persist!
    errors.empty?
  end

  def curriculum_tree
    @curriculum_tree ||= CurriculumTree.find(id)
  end

  def presenter
    CurriculumTreePresenter.new(curriculum_tree)
  end

  private

  def persist!
    ActiveRecord::Base.transaction do
      curriculum_tree.update!(tree: tree) if tree.present?
      handle_change_log
    end
  end

  def parse_attrs(params)
    { tree: parse_tree(params), change_log: parse_change_log(params) }
  end

  # Parse tree from the jstree json input data
  # INPUT:
  #  '[{ "id": "j1_86", "text": "node name", "icon":true, "li_attr":{...},
  #    "a_attr":{...}, "state":{...}, "data":{}, "children":[...] }]'
  # OUTPUT:
  #  [{name: "node name", children: [...]}]
  def parse_tree(params)
    return nil unless params[:tree].present?

    tree_data = JSON.parse(params[:tree])
    tree_data.map { |node| parse_tree_node(node) }
  end

  def parse_tree_node(node)
    {
      name: node['text'].try(:downcase),
      children: node['children'].map { |child| parse_tree_node(child) }
    }
  end

  def parse_change_log(params)
    return nil unless params[:change_log].present?

    JSON.parse(params[:change_log])
  end

  # Reflect curriculum changes on corresponding resources
  def handle_change_log
    change_log.each do |change|
      case change['op']
      when 'rename' then handle_rename(change['from'], change['to'])
      when 'create' then handle_create(change['chain'])
      when 'delete' then handle_delete(change['chain'])
      end
    end
  end

  def handle_rename(from, to)
    Resource.tree.where_curriculum(from).each do |res|
      # the rename is always on the last item for each change
      dir = res.curriculum_directory - [from.last] + [to.last]
      res.update skip_update_curriculum_tree: true, curriculum_directory: dir
    end
  end

  def handle_create(chain)
    Resource.create_from_curriculum(chain)
  end

  def handle_delete(chain)
    Resource.tree.where_curriculum(chain).each do |res|
      res.update curriculum_tree: nil
    end
  end
end
