require 'test_helper'

class SubtitlesImportTestCase < ActionDispatch::IntegrationTest
  def setup
    super

    @not_spreadsheet    = Rails.root.join('test', 'fixtures', 'spreadsheets', 'not_spreadsheet.txt')
    @not_enough_columns = Rails.root.join('test', 'fixtures', 'spreadsheets', 'not_enough_columns.xlsx')
    @too_much_columns   = Rails.root.join('test', 'fixtures', 'spreadsheets', 'too_much_columns.xlsx')

    login_as users(:admin)
    visit '/admin/subtitles_imports/new'
  end

  def test_validation
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal "can't be blank", page.find('.form-group.subtitles_importer_file.has-error .help-block').text

    attach_file 'File', @not_spreadsheet
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal 'has incorrect type', page.find('.form-group.subtitles_importer_file.has-error .help-block').text

    attach_file 'File', @not_enough_columns
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal 'incorrect format: 4 columns instead of 5', page.find('.form-group.subtitles_importer_file.has-error .help-block').text

    attach_file 'File', @too_much_columns
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert has_no_selector?('.form-group.subtitles_importer_file.has-error .help-block')
  end

  def test_results_page
    visit '/admin/subtitles_imports'
    assert_equal '/admin/subtitles_imports/new', current_path
  end

  def test_ods_import
    test_import(Rails.root.join('test', 'fixtures', 'spreadsheets', 'valid_spreadsheet.ods'))
  end

  def test_xlsx_import
    test_import(Rails.root.join('test', 'fixtures', 'spreadsheets', 'valid_spreadsheet.xlsx'))
  end

  def test_empty_import
    attach_file 'File', Rails.root.join('test', 'fixtures', 'spreadsheets', 'empty_valid_spreadsheet.ods')
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert has_content?('Nothing was imported')

    click_link 'Import subtitles'
    attach_file 'File', Rails.root.join('test', 'fixtures', 'spreadsheets', 'empty_valid_spreadsheet.xlsx')
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert has_content?('Nothing was imported')
  end

  private
    def test_import(file)
      # ID 1 has EMPTY subtitle in the DB and NON-EMPTY subtitle in the file
      resource1 = Resource.find_or_create_by!(id: 1)
      resource1.update_column(:subtitle, nil)
      # ID 1 has NON-EMPTY description in the DB and NON-EMPTY description in the file
      resource1.update_column(:description, Faker::Lorem.paragraph)

      # ID 2 has NON-EMPTY subtitle in the DB and EMPTY subtitle in the file
      resource2 = Resource.find_or_create_by!(id: 2)
      subtitle2 = Faker::Lorem.sentence
      resource2.update_column(:subtitle, subtitle2)
      # ID 2 has EMPTY description in the DB and NON-EMPTY description in the file
      resource2.update_column(:description, nil)

      # ID 3 has NON-EMPTY subtitle in the DB and NON-EMPTY subtitle in the file
      resource3 = Resource.find_or_create_by!(id: 3)
      resource3.update_column(:subtitle, Faker::Lorem.sentence)
      # ID 3 has NON-EMPTY description in the DB and EMPTY description in the file
      description3 = Faker::Lorem.paragraph
      resource3.update_column(:description, description3)

      # ID 4 doesn't exist
      Resource.where(id: 4).delete_all

      # ID 5 has EMPTY both description and sutitles in the file
      resource5 = Resource.find_or_create_by!(id: 5)
      subtitle5 = Faker::Lorem.sentence
      resource5.update_column(:subtitle, subtitle5)
      description5 = Faker::Lorem.paragraph
      resource5.update_column(:description, description5)

      attach_file 'File', file
      click_button 'Import'
      assert_equal '/admin/subtitles_imports', current_path
      assert_equal 3, all('tr.resource').size
      assert_equal '3 resource(s) updated', find('p.results-count').text

      assert_equal 'Description 1', resource1.reload.description
      assert_equal 'Description 2', resource2.reload.description
      assert_equal description3,    resource3.reload.description
      assert_equal description5,    resource5.reload.description

      assert_equal 'Subtitle 1', resource1.subtitle
      assert_equal subtitle2,    resource2.subtitle
      assert_equal 'Subtitle 3', resource3.subtitle
      assert_equal subtitle5,    resource5.subtitle

      within '#resource_1' do
        assert_equal resource1.id.to_s,     find('td.id').text
        assert_equal resource1.subtitle,    find('td.subtitle').text
        assert_equal resource1.description, find('td.description').text
      end

      within '#resource_2' do
        assert_equal resource2.id.to_s,     find('td.id').text
        assert_equal resource2.subtitle,    find('td.subtitle').text
        assert_equal resource2.description, find('td.description').text
      end

      within '#resource_3' do
        assert_equal resource3.id.to_s,     find('td.id').text
        assert_equal resource3.subtitle,    find('td.subtitle').text
        assert_equal resource3.description, find('td.description').text
      end
    end
end
