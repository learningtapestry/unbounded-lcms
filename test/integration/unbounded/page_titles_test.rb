require 'test_helper'

class PageTitlesTestCase < IntegrationTestCase
  def setup
    super

    if method_name =~ /_admin_/
      login_as users(:admin)
    end
  end

  def test_about_page
    page = pages(:about)
    visit '/about'
    assert_page_title page.title
  end

  def test_admin_page
    visit '/admin'
    assert_page_title 'Admin'
  end

  def test_admin_collection_type_pages
    collection_type = lobject_collection_types(:nti)

    visit '/admin/collection_types'
    assert_page_title 'Collection Types'

    visit '/admin/collection_types/new'
    assert_page_title 'New Collection Type'

    visit "/admin/collection_types/#{collection_type.id}"
    assert_page_title collection_type.name

    visit "/admin/collection_types/#{collection_type.id}/edit"
    assert_page_title "Edit #{collection_type.name} Collection Type"
  end

  def test_admin_collection_pages
    collection = lobject_collections(:math_root_collection)

    visit '/admin/collections'
    assert_page_title 'Collections'

    visit '/admin/collections/new'
    assert_page_title 'New Collection'

    visit "/admin/collections/#{collection.id}"
    assert_page_title "#{collection.lobject.title} Collection"

    visit "/admin/collections/#{collection.id}/edit"
    assert_page_title "Edit #{collection.lobject.title} Collection"
  end

  def test_admin_page_pages
    tos = pages(:tos)

    visit '/admin/pages'
    assert_page_title 'Pages'

    visit '/admin/pages/new'
    assert_page_title 'New Page'

    visit "/admin/pages/#{tos.id}/edit"
    assert_page_title "Edit #{tos.title} Page"
  end

  def test_admin_resources_pages
    resource = lobjects(:unbounded_unit_1_3_1)

    visit '/admin/lobjects'
    assert_page_title 'Content Administration'

    visit '/admin/lobjects/new'
    assert_page_title 'New Resource'

    visit "/admin/lobjects/#{resource.id}/edit"
    assert_page_title "Edit #{resource.title}"

    visit "/admin/lobject_bulk_edits/new?ids%5B%5D=#{resource.id}"
    assert_page_title 'Edit Tags'
  end

  def test_admin_staff_member_pages
    staff_member = StaffMember.create!(name: Faker::Name.name)

    visit '/admin/staff_members'
    assert_page_title 'Staff Members'

    visit '/admin/staff_members/new'
    assert_page_title 'New Staff Member'

    visit "/admin/staff_members/#{staff_member.id}/edit"
    assert_page_title staff_member.name
  end

  def test_auth_pages
    visit '/users/password/new'
    assert_page_title 'Forgot Your Password?'

    visit '/users/sign_in'
    assert_page_title 'Log In'

    visit '/users/sign_up'
    assert_page_title 'Sign Up'
  end

  def test_curriculum_page
    visit '/curriculum'
    assert_page_title 'Curriculum'
  end

  def test_home_page
    visit '/'
    assert_page_title 'Unbounded Content Browser'
  end

  def test_resource_page
    lobject = lobjects(:unbounded_lesson_1_1_2_1)
    visit "/resources/#{lobject.id}"
    assert_page_title lobject.title
  end

  def test_search_page
    visit '/search'
    assert_page_title 'Search'
  end

  def test_tos_page
    page = pages(:tos)
    visit '/tos'
    assert_page_title page.title
  end

  private
    def assert_page_title(value)
      message = "Expected page title to be '#{value}', actually is '#{page.title}'"
      assert value == page.title, message
    end
end
