require 'test_helper'

class ResourcePresenterTest < ActiveSupport::TestCase
  setup do
    curriculums(:math_map).create_tree
    @resource = resources(:math_lesson_1)
    @curriculum = Curriculum.trees
      .joins(:resource_item)
      .where(resources: { id: @resource.id })
      .first
    @resource.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.'
    @presenter = ResourcePresenter.new @resource
  end

  test 'tags' do
    @resource.tag_list.add('TagX')
    @resource.save!
    @resource.reload
    assert_equal 'TagX', @presenter.tags
  end
end
