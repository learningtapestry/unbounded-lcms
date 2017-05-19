# Handle the form data from the CurriculumTreeEditor admin component
class CurriculumTreeForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, Integer, presence: true
  attribute :tree, Array[Hash], presence: true
  attribute :change_log, Array[Hash]

  def initialize(id, params)
    attrs = parse_attrs(params).merge(id: id)
    super(attrs)
  end

  def save
    return false unless valid?

    persist!
    errors.empty?
  end

  private

  def persist!
    curriculum = CurriculumTree.find(id)
    curriculum.update!(tree: tree)
    # TODO: after we refactor the resources, implement the  handle_change_log
    #       method and uncomment the call bellow
    # handle_change_log
  end

  def parse_attrs(params)
    { tree: parse_tree(params), change_log: JSON.parse(params[:change_log]) }
  end

  # Parse tree from the jstree json input data
  # INPUT:
  #  '[{ "id": "j1_86", "text": "node name", "icon":true, "li_attr":{...},
  #    "a_attr":{...}, "state":{...}, "data":{}, "children":[...] }]'
  # OUTPUT:
  #  [{name: "node name", children: [...]}]
  def parse_tree(params)
    tree_data = JSON.parse(params[:tree])
    tree_data.map { |node| parse_tree_node(node) }
  end

  def parse_tree_node(node)
    {
      name: node['text'],
      children: node['children'].map { |child| parse_tree_node(child) }
    }
  end

  # Reflect curriculum changes on corresponding resources
  def handle_change_log
    raise NotImplementedError
  end
end
