require 'test_helper'

class ResourcePresenterTest < ActiveSupport::TestCase
  setup do
    curriculums(:math_map).create_tree
    @subject = subjects(:math)
    @resource = resources(:math_lesson_1)
    @curriculum = Curriculum.trees
      .joins(:resource_item)
      .where(resources: { id: @resource.id })
      .first
    @resource.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.'
    @presenter = ResourcePresenter.new @resource
  end

  test 'teaser_text' do
    assert @presenter.teaser_text.length < @resource.description.length
  end

  test 'tags' do
    @resource.subjects << Subject.new(name: 'TagX')
    assert_equal 'math, TagX', @presenter.tags
  end
end
