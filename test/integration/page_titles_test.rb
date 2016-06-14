require 'test_helper'

class PageTitlesTestCase < ActionDispatch::IntegrationTest
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

  def test_admin_import_page
    visit '/admin/subtitles_imports/new'
    assert_page_title 'Import subtitles & descriptions'
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
    resource = resources(:unbounded_unit_1_3_1)

    visit '/admin/resources'
    assert_page_title 'Content Administration'

    visit '/admin/resources/new'
    assert_page_title 'New Resource'

    visit "/admin/resources/#{resource.id}/edit"
    assert_page_title "Edit #{resource.title}"

    visit "/admin/resource_bulk_edits/new?ids%5B%5D=#{resource.id}"
    assert_page_title 'Edit Tags'
  end

  def test_admin_staff_member_pages
    fname, lname = Faker::Name.name.split(' ')
    staff_member = StaffMember.create!(first_name: fname, last_name: lname)

    visit '/admin/staff_members'
    assert_page_title 'Staff Members'

    visit '/admin/staff_members/new'
    assert_page_title 'New Staff Member'

    visit "/admin/staff_members/#{staff_member.id}/edit"
    assert_page_title "UnboundEd - #{staff_member.name}"
  end

  def test_auth_pages
    visit '/users/password/new'
    assert_page_title 'Forgot Your Password?'

    visit '/users/sign_in'
    assert_page_title 'Log In'

    visit '/users/sign_up'
    assert_page_title 'Log In'
  end

  def test_home_page
    visit '/'
    assert page.title == 'UnboundEd'
  end

  def test_tos_page
    page = pages(:tos)
    visit '/tos'
    assert_page_title page.title
  end

  private
    def assert_page_title(value)
      message = "Expected page title to include '#{value}', actually is '#{page.title}'"
      assert page.title.include?(value), message
    end
end
