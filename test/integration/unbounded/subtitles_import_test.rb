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
      # ID 1 has NON-EMPTY description in the DB and NON-EMPTY description in the file
      lobject_description = lobject1.lobject_descriptions.first || lobject1.lobject_descriptions.create!
      lobject_description.update_column(:description, Faker::Lorem.paragraph)

      # ID 2 has NON-EMPTY subtitle in the DB and EMPTY subtitle in the file
      lobject2 = Lobject.find_or_create_by!(id: 2)
      lobject_title = lobject2.lobject_titles.first || lobject2.lobject_titles.create!
      subtitle2 = Faker::Lorem.sentence
      lobject_title.update_column(:subtitle, subtitle2)
      # ID 2 has EMPTY description in the DB and NON-EMPTY description in the file
      lobject2.lobject_descriptions.delete_all

      # ID 3 has NON-EMPTY subtitle in the DB and NON-EMPTY subtitle in the file
      lobject3 = Lobject.find_or_create_by!(id: 3)
      lobject_title = lobject3.lobject_titles.first || lobject3.lobject_titles.create!
      lobject_title.update_column(:subtitle, Faker::Lorem.sentence)
      # ID 3 has NON-EMPTY description in the DB and EMPTY description in the file
      lobject_description = lobject3.lobject_descriptions.first || lobject3.lobject_descriptions.create!
      description3 = Faker::Lorem.paragraph
      lobject_description.update_column(:description, description3)

      # ID 4 doesn't exist
      Lobject.where(id: 4).delete_all

      # ID 5 has EMPTY both description and sutitles in the file
      lobject5 = Lobject.find_or_create_by!(id: 5)
      lobject_title = lobject5.lobject_titles.first || lobject5.lobject_titles.create!
      subtitle5 = Faker::Lorem.sentence
      lobject_title.update_column(:subtitle, subtitle5)
      lobject_description = lobject5.lobject_descriptions.first || lobject5.lobject_descriptions.create!
      description5 = Faker::Lorem.paragraph
      lobject_description.update_column(:description, description5)

      attach_file 'File', file
      click_button 'Import'
      assert_equal '/admin/subtitles_imports', current_path
      assert_equal 3, all('tr.lobject').size

      assert_equal 'Description 1', lobject1.reload.description
      assert_equal 'Description 2', lobject2.reload.description
      assert_equal description3,    lobject3.reload.description
      assert_equal description5,    lobject5.reload.description

      assert_equal 'Subtitle 1', lobject1.subtitle
      assert_equal subtitle2,    lobject2.subtitle
      assert_equal 'Subtitle 3', lobject3.subtitle
      assert_equal subtitle5,    lobject5.subtitle

      within '#lobject_1' do
        assert_equal lobject1.id.to_s,     find('td.id').text
        assert_equal lobject1.subtitle,    find('td.subtitle').text
        assert_equal lobject1.description, find('td.description').text
      end

      within '#lobject_2' do
        assert_equal lobject2.id.to_s,     find('td.id').text
        assert_equal lobject2.subtitle,    find('td.subtitle').text
        assert_equal lobject2.description, find('td.description').text
      end

      within '#lobject_3' do
        assert_equal lobject3.id.to_s,     find('td.id').text
        assert_equal lobject3.subtitle,    find('td.subtitle').text
        assert_equal lobject3.description, find('td.description').text
      end
    end
end
