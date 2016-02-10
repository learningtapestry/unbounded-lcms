require 'test_helper'

class ResourcesTestCase < ActionDispatch::IntegrationTest
  def setup
    super

    @admin          = users(:admin)
    @alignment1     = alignments(:mp1)
    @alignment2     = alignments(:mp2)
    @description    = Faker::Lorem.sentence(10)
    @easol_resource  = resources(:easol)
    @grade1         = grades(:grade1)
    @grade2         = grades(:grade2)
    @other_resource  = resources(:no_organization)
    @resource_type1 = resource_types(:video)
    @resource_type2 = resource_types(:textbook)
    @subject1       = subjects(:math)
    @subject2       = subjects(:physics)
    @subtitle       = Faker::Lorem.sentence
    @title          = Faker::Lorem.sentence
    @topic1         = topics(:stem)
    @topic2         = topics(:video_library)

    login_as @admin
  end

  def test_new_resource
    visit '/admin'
    click_link 'Resources'
    assert_equal current_path, '/admin/resources'
    click_link 'Add Resource'
    assert_equal current_path, '/admin/resources/new'

    fill_in 'Title',       with: @title
    fill_in 'Subtitle',    with: @subtitle
    fill_in 'Description', with: @description
    check 'Hidden'
    select @grade1.grade,         from: 'Grades'
    select @grade2.grade,         from: 'Grades'
    select @subject1.name,        from: 'Subjects'
    select @subject2.name,        from: 'Subjects'
    select @topic1.name,          from: 'Topics'
    select @topic2.name,          from: 'Topics'
    select @resource_type1.name,  from: 'Resource types'
    select @resource_type2.name,  from: 'Resource types'
    select @alignment1.name,      from: 'Alignments'
    select @alignment2.name,      from: 'Alignments'
    select @easol_resource.title,  from: 'Related materials'
    select @other_resource.title, from: 'Additional materials'
    within '#resource_form' do
      click_button 'Save'
    end

    resource = Resource.last
    assert_equal current_path, "/resources/#{resource.id}"
    assert_equal resource.description,  @description
    assert_equal resource.hidden?,      true
    assert_equal resource.subtitle,     @subtitle
    assert_equal resource.title,        @title
    assert_same_elements resource.additional_resources, [@other_resource]
    assert_same_elements resource.alignments,          [@alignment1, @alignment2]
    assert_same_elements resource.grades,              [@grade1, @grade2]
    assert_same_elements resource.related_resources,    [@easol_resource]
    assert_same_elements resource.resource_types,      [@resource_type1, @resource_type2]
    assert_same_elements resource.subjects,            [@subject1, @subject2]
    assert_same_elements resource.topics,              [@topic1, @topic2]
  end

  def test_edit_unbounded_resource
    resource = resources(:unbounded)
    visit "/resources/#{resource.id}"
    click_link 'Edit'
    assert_equal current_path, "/admin/resources/#{resource.id}/edit"

    fill_in 'Title',       with: @title
    fill_in 'Subtitle',    with: @subtitle
    fill_in 'Description', with: @description
    uncheck 'Hidden'
    resource.grades.each { |grade| unselect grade.grade, from: 'Grades' }
    select @grade2.grade, from: 'Grades'
    resource.subjects.each { |subject| unselect subject.name, from: 'Subjects' }
    select @subject2.name, from: 'Subjects'
    resource.topics.each { |topic| unselect topic.name, from: 'Topics' }
    select @topic2.name, from: 'Topics'
    resource.resource_types.each { |resource_type| unselect resource_type.name, from: 'Resource types' }
    select @resource_type2.name, from: 'Resource types'
    resource.alignments.each { |alignment| unselect alignment.name, from: 'Alignments' }
    select @alignment2.name, from: 'Alignments'
    unselect @easol_resource.title, from: 'Related materials'
    select @other_resource.title, from: 'Related materials'
    unselect @other_resource.title, from: 'Additional materials'
    select @easol_resource.title, from: 'Additional materials'
    within '#resource_form' do
      click_button 'Save'
    end

    resource.reload
    assert_equal current_path, "/resources/#{resource.id}"
    assert_equal resource.description, @description
    assert_equal resource.hidden?,     false
    assert_equal resource.subtitle,    @subtitle
    assert_equal resource.title,       @title
    assert_same_elements resource.additional_resources, [@easol_resource]
    assert_same_elements resource.alignments,          [@alignment2]
    assert_same_elements resource.grades,              [@grade2]
    assert_same_elements resource.related_resources,    [@other_resource]
    assert_same_elements resource.resource_types,      [@resource_type2]
    assert_same_elements resource.subjects,            [@subject2]
    assert_same_elements resource.topics,              [@topic2]
  end

  def test_delete_unbounded_resource
    resource = resources(:unbounded)
    visit "/resources/#{resource.id}"
    click_button 'Delete'

    assert_nil Resource.find_by_id(resource.id)
    assert_equal current_path, '/admin/resources'
    assert_equal page.find('.alert.alert-success').text, "× Resource ##{resource.id} was deleted successfully."
  end
end
