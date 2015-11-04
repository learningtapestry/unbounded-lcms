require 'test_helper'

class SubtitlesImportTestCase < IntegrationTestCase
  include Content::Models

  def setup
    super

    @not_spreadsheet    = Rails.root.join('test', 'fixtures', 'spreadsheets', 'not_spreadsheet.txt')
    @not_enough_columns = Rails.root.join('test', 'fixtures', 'spreadsheets', 'not_enough_columns.xlsx')
    @too_much_columns   = Rails.root.join('test', 'fixtures', 'spreadsheets', 'too_much_columns.xlsx')

    login_as users(:admin)
    visit '/admin'
    click_link 'Resources'
    click_link 'Import subtitles'
    assert_equal '/admin/subtitles_imports/new', current_path
  end

  def test_validation
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal "can't be blank", page.find('.form-group.content_importers_subtitles_importer_file.has-error .help-block').text

    attach_file 'File', @not_spreadsheet
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal 'has incorrect type', page.find('.form-group.content_importers_subtitles_importer_file.has-error .help-block').text

    attach_file 'File', @not_enough_columns
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal 'incorrect format: 4 columns instead of 5', page.find('.form-group.content_importers_subtitles_importer_file.has-error .help-block').text

    attach_file 'File', @too_much_columns
    click_button 'Import'
    assert_equal '/admin/subtitles_imports', current_path
    assert_equal 'incorrect format: 6 columns instead of 5', page.find('.form-group.content_importers_subtitles_importer_file.has-error .help-block').text
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
      lobject1 = Lobject.find_or_create_by!(id: 1)
      lobject1.lobject_titles.delete_all

      # ID 2 has NON-EMPTY subtitle in the DB and EMPTY subtitle in the file
      lobject2 = Lobject.find_or_create_by!(id: 2)
      lobject_title = lobject2.lobject_titles.first || lobject2.lobject_titles.create!
      subtitle2 = Faker::Lorem.sentence
      lobject_title.update_column(:subtitle, subtitle2)

      # ID 3 has NON-EMPTY subtitle in the DB and NON-EMPTY subtitle in the file
      lobject3 = Lobject.find_or_create_by!(id: 3)
      lobject_title = lobject3.lobject_titles.first || lobject3.lobject_titles.create!
      lobject_title.update_column(:subtitle, Faker::Lorem.sentence)

      # ID 4 doesn't exist
      Lobject.where(id: 4).delete_all

      attach_file 'File', file
      click_button 'Import'
      assert_equal '/admin/subtitles_imports', current_path
      assert_equal 2, all('tr.lobject').size

      within '#lobject_1' do
        assert_equal '1',          find('td.id').text
        assert_equal 'Subtitle 1', find('td.subtitle').text
      end

      within '#lobject_3' do
        assert_equal '3',          find('td.id').text
        assert_equal 'Subtitle 3', find('td.subtitle').text
      end

      assert_equal 'Subtitle 1', lobject1.reload.subtitle
      assert_equal subtitle2,    lobject2.reload.subtitle
      assert_equal 'Subtitle 3', lobject3.reload.subtitle
    end
end
