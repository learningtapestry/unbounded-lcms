require 'test_helper'

feature 'Lobjects management' do
  let(:admin)          { create :admin }
  let(:alignment1)     { create :alignment }
  let(:alignment2)     { create :alignment }
  let(:description)    { Faker::Lorem.sentence(10) }
  let(:grade1)         { create :grade }
  let(:grade2)         { create :grade }
  let(:language)       { create :language }
  let(:organization)   { create :organization }
  let(:resource_type1) { create :resource_type }
  let(:resource_type2) { create :resource_type }
  let(:subject1)       { create :subject }
  let(:subject2)       { create :subject }
  let(:title)          { Faker::Lorem.sentence }
  let(:topic1)         { create :topic }
  let(:topic2)         { create :topic }
  let(:unbounded_org)  { Content::Models::Organization.unbounded }
  let(:url)            { Faker::Internet.url }

  before do
    alignment1
    alignment2
    grade1
    grade2
    language
    resource_type1
    resource_type2
    subject1
    subject2
    topic1
    topic2

    login_as admin
  end

  describe 'Create Lobject' do
    scenario do
      visit '/unbounded/admin'
      click_link 'Add Learning Object'
      assert_equal current_path, '/unbounded/admin/lobjects/new'

      click_button 'Save'
      # [TODO] add validation on title for new Lobjects
      # page.must_have_selector '.form-group.content_models_lobject_lobject_titles_title.has-error .help-block', text: "can't be blank"
      page.must_have_selector '.form-group.content_models_lobject_lobject_urls_url_url.has-error .help-block', text: "can't be blank"

      fill_in 'Title',       with: title
      fill_in 'URL',         with: url
      fill_in 'Description', with: description
      select language.name,       from: 'Language'
      select grade1.grade,        from: 'Grades'
      select grade2.grade,        from: 'Grades'
      select subject1.name,       from: 'Subjects'
      select subject2.name,       from: 'Subjects'
      select topic1.name,         from: 'Topics'
      select topic2.name,         from: 'Topics'
      select resource_type1.name, from: 'Resource types'
      select resource_type2.name, from: 'Resource types'
      select alignment1.name,     from: 'Alignments'
      select alignment2.name,     from: 'Alignments'
      click_button 'Save'

      lobject = Content::Models::Lobject.last
      assert_equal current_path, "/unbounded/show/#{lobject.id}"
      assert_equal lobject.description,  description
      assert_equal lobject.language,     language
      assert_equal lobject.organization, unbounded_org
      assert_equal lobject.title,        title
      assert_equal lobject.url.url,      url
      assert_same_elements lobject.alignments,     [alignment1, alignment2]
      assert_same_elements lobject.grades,         [grade1, grade2]
      assert_same_elements lobject.resource_types, [resource_type1, resource_type2]
      assert_same_elements lobject.subjects,       [subject1, subject2]
      assert_same_elements lobject.topics,         [topic1, topic2]
    end
  end

  describe 'Edit Lobject' do
    scenario 'empty organization' do
      lobject = create :lobject
      assert_raise ActiveRecord::RecordNotFound do
        visit "/unbounded/admin/lobjects/#{lobject.id}/edit"
      end
    end

    scenario 'incorrect organization' do
      lobject = create :lobject, organization: organization
      assert_raise ActiveRecord::RecordNotFound do
        visit "/unbounded/admin/lobjects/#{lobject.id}/edit"
      end
    end

    scenario do
      lobject = create :lobject, organization: unbounded_org
      visit "/unbounded/show/#{lobject.id}"
      click_link 'Edit'
      assert_equal current_path, "/unbounded/admin/lobjects/#{lobject.id}/edit"

      fill_in 'Title',       with: title
      fill_in 'URL',         with: url
      fill_in 'Description', with: description
      select language.name, from: 'Language'
      lobject.grades.each { |grade| unselect grade.grade, from: 'Grades' }
      select grade2.grade, from: 'Grades'
      lobject.subjects.each { |subject| unselect subject.name, from: 'Subjects' }
      select subject2.name, from: 'Subjects'
      lobject.topics.each { |topic| unselect topic.name, from: 'Topics' }
      select topic2.name, from: 'Topics'
      lobject.resource_types.each { |resource_type| unselect resource_type.name, from: 'Resource types' }
      select resource_type2.name, from: 'Resource types'
      lobject.alignments.each { |alignment| unselect alignment.name, from: 'Alignments' }
      select alignment2.name, from: 'Alignments'
      click_button 'Save'      

      lobject.reload
      assert_equal current_path, "/unbounded/show/#{lobject.id}"
      assert_equal lobject.description, description
      assert_equal lobject.language,    language
      assert_equal lobject.title,       title
      assert_equal lobject.url.url,     url
      assert_same_elements lobject.alignments,     [alignment2]
      assert_same_elements lobject.grades,         [grade2]
      assert_same_elements lobject.resource_types, [resource_type2]
      assert_same_elements lobject.subjects,       [subject2]
      assert_same_elements lobject.topics,         [topic2]
    end
  end

  describe 'Delete Lobject' do
    scenario 'empty organization' do
      lobject = create :lobject
      assert_raise ActiveRecord::RecordNotFound do
        visit "/unbounded/admin/lobjects/#{lobject.id}/delete"
      end
    end

    scenario 'incorrect organization' do
      lobject = create :lobject, organization: organization
      assert_raise ActiveRecord::RecordNotFound do
        visit "/unbounded/admin/lobjects/#{lobject.id}/delete"
      end
    end

    scenario do
      lobject = create :lobject, organization: unbounded_org
      visit "/unbounded/show/#{lobject.id}"
      click_link 'Delete'

      assert_nil Content::Models::Lobject.find_by_id(lobject.id)
      assert_equal current_path, '/unbounded'
      page.must_have_selector '.alert.alert-success', text: "Learning Object ##{lobject.id} was deleted successfully."
    end
  end
end
