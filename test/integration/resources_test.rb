require 'test_helper'

class ResourcesTestCase < ActionDispatch::IntegrationTest
  def setup
    super

    @admin          = users(:admin)
    @standard1     = standards(:mp1)
    @standard2     = standards(:mp2)
    @description    = Faker::Lorem.sentence(10)
    @easol_resource  = resources(:easol)
    @grade1         = 'grade 1'
    @grade2         = 'grade 2'
    @other_resource  = resources(:no_organization)
    @resource_type1 = 'resource type 1'
    @resource_type2 = 'resource type 2'
    @tag1       = 'tag 1'
    @tag2       = 'tag 2'
    @subtitle       = Faker::Lorem.sentence
    @title          = Faker::Lorem.sentence
    @topic1         = 'topic 1'
    @topic2         = 'topic 2'

    login_as @admin
  end

  def test_new_resource
    visit '/admin/resources/new'

    fill_in 'Title',       with: @title
    fill_in 'Subtitle',    with: @subtitle
    fill_in 'Description', with: @description
    check 'Hidden'
    select @grade1,         from: 'Grade list'
    select @grade2,         from: 'Grade list'
    select @tag1,        from: 'Tag list'
    select @tag2,        from: 'Tag list'
    select @topic1,          from: 'Topic list'
    select @topic2,          from: 'Topic list'
    select @resource_type1,  from: 'Resource type list'
    select @resource_type2,  from: 'Resource type list'
    select @standard1.name,      from: 'Standards'
    select @standard2.name,      from: 'Standards'
    select @easol_resource.title,  from: 'Related materials'
    select @other_resource.title, from: 'Additional materials'
    within '#resource_form' do
      click_button 'Save'
    end

    resource = Resource.last
    assert_equal resource.description,  @description
    assert_equal resource.hidden?,      true
    assert_equal resource.subtitle,     @subtitle
    assert_equal resource.title,        @title
    assert_same_elements resource.additional_resources, [@other_resource]
    assert_same_elements resource.standards,          [@standard1, @standard2]
    assert_same_elements resource.grade_list,              [@grade1, @grade2]
    assert_same_elements resource.related_resources,    [@easol_resource]
    assert_same_elements resource.resource_type_list,      [@resource_type1, @resource_type2]
    assert_same_elements resource.tag_list,            [@tag1, @tag2]
    assert_same_elements resource.topic_list,              [@topic1, @topic2]
  end

  def test_edit_unbounded_resource
    resource = resources(:unbounded)
    visit "/admin/resources/#{resource.id}/edit"

    fill_in 'Title',       with: @title
    fill_in 'Subtitle',    with: @subtitle
    fill_in 'Description', with: @description
    uncheck 'Hidden'
    resource.grade_list.each { |grade| unselect grade, from: 'Grade list' }
    select @grade2, from: 'Grade list'
    resource.tag_list.each { |subject| unselect subject, from: 'Tag list' }
    select @tag2, from: 'Tag list'
    resource.topic_list.each { |topic| unselect topic, from: 'Topic list' }
    select @topic2, from: 'Topic list'
    resource.resource_type_list.each { |resource_type| unselect resource_type, from: 'Resource type list' }
    select @resource_type2, from: 'Resource type list'
    resource.standards.each { |standard| unselect standard.name, from: 'Standards' }
    select @standard2.name, from: 'Standards'
    unselect @easol_resource.title, from: 'Related materials'
    select @other_resource.title, from: 'Related materials'
    unselect @other_resource.title, from: 'Additional materials'
    select @easol_resource.title, from: 'Additional materials'
    within '#resource_form' do
      click_button 'Save'
    end

    resource.reload
    assert_equal resource.description, @description
    assert_equal resource.hidden?,     false
    assert_equal resource.subtitle,    @subtitle
    assert_equal resource.title,       @title
    assert_same_elements resource.additional_resources, [@easol_resource]
    assert_same_elements resource.standards,          [@standard2]
    assert_same_elements resource.grade_list,              [@grade2]
    assert_same_elements resource.related_resources,    [@other_resource]
    assert_same_elements resource.resource_type_list,      [@resource_type2]
    assert_same_elements resource.tag_list,            [@tag2]
    assert_same_elements resource.topic_list,              [@topic2]
  end

  def test_delete_unbounded_resource
    resource = resources(:unbounded)
    visit "/admin/resources/#{resource.id}/edit"
    click_link 'Delete'

    assert_nil Resource.find_by_id(resource.id)
    assert_equal current_path, '/admin/resources'
    assert_equal page.find('.callout.success').text, "Resource ##{resource.id} was deleted successfully. ×"
  end
end
