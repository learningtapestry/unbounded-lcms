# Handle the form data from the CurriculumEditor admin component
class CurriculumForm
  include Virtus.model
  include ActiveModel::Model

  attribute :change_log, Array[Hash]

  def initialize(params = {})
    super(change_log: parse_change_log(params))
  end

  def save
    return false unless valid?

    persist!
    errors.empty?
  end

  private

  def persist!
    handle_change_log
    update_positions
  end

  def parse_change_log(params)
    return nil unless params && params[:change_log].present?
    JSON.parse(params[:change_log])
  end

  def find_resource_by(id, curr)
    Resource.tree.find_by(id: id) || Resource.tree.find_by_curriculum(curr)
  end

  # Reflect curriculum changes on corresponding resources
  def handle_change_log
    change_log.each do |change|
      case change['op']
      when 'create' then handle_create(change)
      when 'move' then handle_move(change)
      when 'remove' then handle_remove(change)
      when 'rename' then handle_rename(change)
      end
    end
  end

  def handle_create(change)
    name = change['name'].presence
    return unless name

    curr_dir = change['curriculum'].push(name)
    return if Resource.tree.find_by_curriculum(curr_dir)

    parent = find_resource_by(change['parent'], change['curriculum'])
    return unless parent

    res = Resource.new(
      curriculum_directory: curr_dir,
      curriculum_type: parent.next_hierarchy_level,
      level_position: parent.children.size,
      parent_id: parent.id,
      resource_type: :resource,
      short_title: name,
      tree: true
    )
    res.title = Breadcrumbs.new(res).title.split(' / ')[0...-1].push(name.titleize).join(' ')
    res.save!
    res
  end

  def handle_move(change)
    resource = find_resource_by(change['id'], change['curriculum'])
    parent = find_resource_by(change['parent'], change['parent_curriculum'])
    return unless resource && parent

    resource.parent = parent
    resource.level_position = change['position']
    resource.save

    parent.children.where.not(id: resource.id).where('level_position >= ?', change['position']).each do |r|
      r.level_position += 1
      r.save
    end
  end

  def handle_remove(change)
    resource = find_resource_by(change['id'], change['curriculum'])
    return unless resource

    resource.update parent: nil, tree: false
    resource.descendants.update_all tree: false
  end

  def handle_rename(change)
    curr = change['curriculum'].try(:push, change['from'])
    resource = find_resource_by(change['id'], curr)
    return unless resource && change['to'].present?

    # change the short_title and directory tags on the resource itself
    resource.short_title = change['to']
    dir = resource.curriculum_directory - [change['from']] + [change['to']]
    resource.curriculum_directory = dir
    resource.save!

    # fix directory tags for the descendants
    resource.descendants.each do |res|
      dir = res.curriculum_directory - [change['from']] + [change['to']]
      res.update curriculum_directory: dir
    end
  end

  def update_positions
    Resource.tree.each do |res|
      res.update_columns hierarchical_position: HierarchicalPosition.new(res).position
    end
  end
end
