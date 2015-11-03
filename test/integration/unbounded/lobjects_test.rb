require 'test_helper'

module Unbounded
  class LobjectsTestCase < IntegrationTestCase
    def setup
      super

      @admin          = users(:admin)
      @alignment1     = alignments(:mp1)
      @alignment2     = alignments(:mp2)
      @description    = Faker::Lorem.sentence(10)
      @easol_lobject  = lobjects(:easol)
      @easol_org      = organizations(:easol)
      @grade1         = grades(:grade1)
      @grade2         = grades(:grade2)
      @language       = languages(:en)
      @no_org_lobject = lobjects(:no_organization)
      @resource_type1 = resource_types(:video)
      @resource_type2 = resource_types(:textbook)
      @subject1       = subjects(:math)
      @subject2       = subjects(:physics)
      @subtitle       = Faker::Lorem.sentence
      @title          = Faker::Lorem.sentence
      @topic1         = topics(:stem)
      @topic2         = topics(:video_library)
      @unbounded_org  = organizations(:unbounded)
      @url            = Faker::Internet.url

      login_as @admin
    end

    def test_new_lobject
      visit '/admin'
      click_link 'Resources'
      assert_equal current_path, '/admin/lobjects'
      click_link 'Add Resource'
      assert_equal current_path, '/admin/lobjects/new'

      within '#lobject_form' do
        click_button 'Save'
      end
      # [TODO] add validation on title for new Lobjects
      # page.must_have_selector '.form-group.content_models_lobject_lobject_titles_title.has-error .help-block', text: "can't be blank"
      assert_equal page.find('.form-group.content_models_lobject_lobject_urls_url_url.has-error .help-block').text, "can't be blank"

      fill_in 'Title',       with: @title
      fill_in 'Subtitle',    with: @subtitle
      fill_in 'URL',         with: @url
      fill_in 'Description', with: @description
      check 'Hidden'
      select @language.name,        from: 'Language'
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
      select @easol_lobject.title,  from: 'Related materials'
      select @no_org_lobject.title, from: 'Additional materials'
      within '#lobject_form' do
        click_button 'Save'
      end

      lobject = Lobject.last
      assert_equal current_path, "/resources/#{lobject.id}"
      assert_equal lobject.description,  @description
      assert_equal lobject.hidden?,      true
      assert_equal lobject.language,     @language
      assert_equal lobject.organization, @unbounded_org
      assert_equal lobject.subtitle,     @subtitle
      assert_equal lobject.title,        @title
      assert_equal lobject.url.url,      @url
      assert_same_elements lobject.additional_lobjects, [@no_org_lobject]
      assert_same_elements lobject.alignments,          [@alignment1, @alignment2]
      assert_same_elements lobject.grades,              [@grade1, @grade2]
      assert_same_elements lobject.related_lobjects,    [@easol_lobject]
      assert_same_elements lobject.resource_types,      [@resource_type1, @resource_type2]
      assert_same_elements lobject.subjects,            [@subject1, @subject2]
      assert_same_elements lobject.topics,              [@topic1, @topic2]
    end

    def test_edit_lobject_without_organization
      lobject = lobjects(:no_organization)
      assert_raise ActiveRecord::RecordNotFound do
        visit "/admin/lobjects/#{lobject.id}/edit"
      end
    end

    def edit_lobject_with_incorrect_organization
      lobject = lobjects(:easol)
      assert_raise ActiveRecord::RecordNotFound do
        visit "/admin/lobjects/#{lobject.id}/edit"
      end
    end

    def test_edit_unbounded_lobject
      lobject = lobjects(:unbounded)
      visit "/resources/#{lobject.id}"
      click_link 'Edit'
      assert_equal current_path, "/admin/lobjects/#{lobject.id}/edit"

      fill_in 'Title',       with: @title
      fill_in 'Subtitle',    with: @subtitle
      fill_in 'URL',         with: @url
      fill_in 'Description', with: @description
      uncheck 'Hidden'
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
      unselect @easol_lobject.title, from: 'Related materials'
      select @no_org_lobject.title, from: 'Related materials'
      unselect @no_org_lobject.title, from: 'Additional materials'
      select @easol_lobject.title, from: 'Additional materials'
      within '#lobject_form' do
        click_button 'Save'
      end

      lobject.reload
      assert_equal current_path, "/resources/#{lobject.id}"
      assert_equal lobject.description, @description
      assert_equal lobject.hidden?,     false
      assert_equal lobject.language,    @language
      assert_equal lobject.subtitle,    @subtitle
      assert_equal lobject.title,       @title
      assert_equal lobject.url.url,     @url
      assert_same_elements lobject.additional_lobjects, [@easol_lobject]
      assert_same_elements lobject.alignments,          [@alignment2]
      assert_same_elements lobject.grades,              [@grade2]
      assert_same_elements lobject.related_lobjects,    [@no_org_lobject]
      assert_same_elements lobject.resource_types,      [@resource_type2]
      assert_same_elements lobject.subjects,            [@subject2]
      assert_same_elements lobject.topics,              [@topic2]
    end

    def test_delete_unbounded_lobject
      lobject = lobjects(:unbounded)
      visit "/resources/#{lobject.id}"
      click_button 'Delete'

      assert_nil Lobject.find_by_id(lobject.id)
      assert_equal current_path, '/'
      assert_equal page.find('.alert.alert-success').text, "× Learning Object ##{lobject.id} was deleted successfully."
    end
  end
end
