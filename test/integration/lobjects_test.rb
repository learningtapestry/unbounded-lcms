require 'test_helper'

class LobjectsTestCase < IntegrationTestCase
  setup do
    @admin          = users(:admin)
    @alignment1     = alignments(:mp1)
    @alignment2     = alignments(:mp2)
    @description    = Faker::Lorem.sentence(10)
    @easol_org      = organizations(:easol)
    @grade1         = grades(:grade1)
    @grade2         = grades(:grade2)
    @language       = languages(:en)
    @resource_type1 = resource_types(:video)
    @resource_type2 = resource_types(:textbook)
    @subject1       = subjects(:math)
    @subject2       = subjects(:physics)
    @title          = Faker::Lorem.sentence
    @topic1         = topics(:stem)
    @topic2         = topics(:video_library)
    @unbounded_org  = organizations(:unbounded)
    @url            = Faker::Internet.url

    login_as @admin
  end

  def test_new_lobject
    visit '/unbounded/admin'
    click_link 'Add Learning Object'
    assert_equal current_path, '/unbounded/admin/lobjects/new'

    click_button 'Save'
    # [TODO] add validation on title for new Lobjects
    # page.must_have_selector '.form-group.content_models_lobject_lobject_titles_title.has-error .help-block', text: "can't be blank"
    assert_equal page.find('.form-group.content_models_lobject_lobject_urls_url_url.has-error .help-block').text, "can't be blank"

    fill_in 'Title',       with: @title
    fill_in 'URL',         with: @url
    fill_in 'Description', with: @description
    select @language.name,       from: 'Language'
    select @grade1.grade,        from: 'Grades'
    select @grade2.grade,        from: 'Grades'
    select @subject1.name,       from: 'Subjects'
    select @subject2.name,       from: 'Subjects'
    select @topic1.name,         from: 'Topics'
    select @topic2.name,         from: 'Topics'
    select @resource_type1.name, from: 'Resource types'
    select @resource_type2.name, from: 'Resource types'
    select @alignment1.name,     from: 'Alignments'
    select @alignment2.name,     from: 'Alignments'
    click_button 'Save'

    lobject = Lobject.last
    assert_equal current_path, "/unbounded/show/#{lobject.id}"
    assert_equal lobject.description,  @description
    assert_equal lobject.language,     @language
    assert_equal lobject.organization, @unbounded_org
    assert_equal lobject.title,        @title
    assert_equal lobject.url.url,      @url
    assert_same_elements lobject.alignments,     [@alignment1, @alignment2]
    assert_same_elements lobject.grades,         [@grade1, @grade2]
    assert_same_elements lobject.resource_types, [@resource_type1, @resource_type2]
    assert_same_elements lobject.subjects,       [@subject1, @subject2]
    assert_same_elements lobject.topics,         [@topic1, @topic2]
  end

  def test_edit_lobject_without_organization
    lobject = lobjects(:no_organization)
    assert_raise ActiveRecord::RecordNotFound do
      visit "/unbounded/admin/lobjects/#{lobject.id}/edit"
    end
  end

  def edit_lobject_with_incorrect_organization
    lobject = lobjects(:easol)
    assert_raise ActiveRecord::RecordNotFound do
      visit "/unbounded/admin/lobjects/#{lobject.id}/edit"
    end
  end

  def test_edit_unbounded_lobject
    lobject = lobjects(:unbounded)
    visit "/unbounded/show/#{lobject.id}"
    click_link 'Edit'
    assert_equal current_path, "/unbounded/admin/lobjects/#{lobject.id}/edit"

    fill_in 'Title',       with: @title
    fill_in 'URL',         with: @url
    fill_in 'Description', with: @description
    select @language.name, from: 'Language'
    lobject.grades.each { |grade| unselect grade.grade, from: 'Grades' }
    select @grade2.grade, from: 'Grades'
    lobject.subjects.each { |subject| unselect subject.name, from: 'Subjects' }
    select @subject2.name, from: 'Subjects'
    lobject.topics.each { |topic| unselect topic.name, from: 'Topics' }
    select @topic2.name, from: 'Topics'
    lobject.resource_types.each { |resource_type| unselect resource_type.name, from: 'Resource types' }
    select @resource_type2.name, from: 'Resource types'
    lobject.alignments.each { |alignment| unselect alignment.name, from: 'Alignments' }
    select @alignment2.name, from: 'Alignments'
    click_button 'Save'

    lobject.reload
    assert_equal current_path, "/unbounded/show/#{lobject.id}"
    assert_equal lobject.description, @description
    assert_equal lobject.language,    @language
    assert_equal lobject.title,       @title
    assert_equal lobject.url.url,     @url
    assert_same_elements lobject.alignments,     [@alignment2]
    assert_same_elements lobject.grades,         [@grade2]
    assert_same_elements lobject.resource_types, [@resource_type2]
    assert_same_elements lobject.subjects,       [@subject2]
    assert_same_elements lobject.topics,         [@topic2]
  end

  def test_delete_lobject_without_organization
    lobject = lobjects(:no_organization)
    assert_raise ActiveRecord::RecordNotFound do
      visit "/unbounded/admin/lobjects/#{lobject.id}/delete"
    end
  end

  def test_delete_lobject_with_incorrect_organization
    lobject = lobjects(:easol)
    assert_raise ActiveRecord::RecordNotFound do
      visit "/unbounded/admin/lobjects/#{lobject.id}/delete"
    end
  end

  def test_delete_unbounded_lobject
    lobject = lobjects(:unbounded)
    visit "/unbounded/show/#{lobject.id}"
    click_link 'Delete'

    assert_nil Lobject.find_by_id(lobject.id)
    assert_equal current_path, '/unbounded'
    assert_equal page.find('.alert.alert-success').text, "× Learning Object ##{lobject.id} was deleted successfully."
  end
end
