require 'csv'
require 'erb'
require 'ostruct'
require 'test_helper'

module Lt
  module Admin
    class CsvImportsTestCase < IntegrationTestCase
      include Content::Models
      include ActiveJob::TestHelper

      def setup
        super
      end

      def test_empty_csv
        navigate_to_import

        within('#new_lt_admin_csv_import') { click_button 'Import data' }

        assert_equal '/lt/admin/csv_imports', current_path
        assert_equal "can't be blank", page.find('.help-block').text
      end

      def test_non_csv
        navigate_to_import

        within('#new_lt_admin_csv_import') do
          attach_file 'File', csv_path('not_a_csv.bin')
          click_button 'Import data'
        end

        assert_equal '/lt/admin/csv_imports', current_path
        assert page.find('.help-block').text.include? 'should be a CSV with the headers'
      end

      def test_bad_csv
        navigate_to_import

        within('#new_lt_admin_csv_import') do
          attach_file 'File', csv_path('bad_csv_import.csv')
          click_button 'Import data'
        end

        assert_equal '/lt/admin/csv_imports', current_path
        assert page.find('.help-block').text.include? 'should be a CSV with the headers'
      end

      def test_csv_import_replace
        navigate_to_import

        csv_file = generate_csv 'csv_import_replace.csv.erb',
          id_1: Lobject.order(id: :asc).first.id,
          id_2: Lobject.order(id: :asc).second.id

        within('#new_lt_admin_csv_import') do
          attach_file 'File', csv_file
          check 'Replace'

          assert_performed_jobs 1 do
            click_button 'Import data'
          end
        end

        assert_equal '/lt/admin/csv_imports/new', current_path
        assert page.find('.alert-success').text.include? 'File import is in progress'
        assert_resources_updated Lobject.order(id: :asc).first, Lobject.order(id: :asc).second
      end

      def test_csv_import_increment
        navigate_to_import

        within('#new_lt_admin_csv_import') do
          attach_file 'File', csv_path('csv_import_increment.csv')
          assert_performed_jobs 1 do
            click_button 'Import data'
          end
        end

        assert_equal '/lt/admin/csv_imports/new', current_path
        assert page.find('.alert-success').text.include? 'File import is in progress'
        assert_resources_updated Lobject.order(id: :desc).second, Lobject.order(id: :desc).first
      end

      def test_export
        navigate_to_import
        # Add resources we're aware of before checking the export file.
        within('#new_lt_admin_csv_import') do
          attach_file 'File', csv_path('csv_import_increment.csv')
          assert_performed_jobs 1 do
            click_button 'Import data'
          end
        end

        click_link 'Export all data as CSV'

        header = page.response_headers['Content-Disposition']
        assert_match (/^attachment/), header
        assert_match (/csv/), header
        exported_csv = CSV.parse(page.body, headers: true)
        assert_equal %w(id url publisher title description grade resource_type standard subject), exported_csv.headers

        exported_lobject_1 = exported_csv[-2]
        assert_equal Lobject.order(id: :desc).second.id.to_s, exported_lobject_1['id']
        assert_equal 'http://npg.si.edu/', exported_lobject_1['url']
        assert_equal 'Smithsonian Education,Another Institution', exported_lobject_1['publisher']
        assert_equal 'Civil War Educational Resources', exported_lobject_1['title']
        assert_equal 'Lesson plans introduce history', exported_lobject_1['description']
        assert_equal 'grade 1,grade 2,grade 3', exported_lobject_1['grade']
        assert_equal 'lesson plan,textbook', exported_lobject_1['resource_type']
        assert_equal 'ELA-Literacy.L.1.4a,ELA-Literacy.SL.4.1a,ELA-Literacy.W.K.8', exported_lobject_1['standard']
        assert_equal 'civil war,education', exported_lobject_1['subject']

        exported_lobject_2 = exported_csv[-1]
        assert_equal Lobject.order(id: :desc).first.id.to_s, exported_lobject_2['id']
        assert_equal 'http://gardens.si.edu', exported_lobject_2['url']
        assert_equal 'Bla: The Great Bla', exported_lobject_2['title']
        refute exported_lobject_2['publisher'].present?
        refute exported_lobject_2['description'].present?
        refute exported_lobject_2['grade'].present?
        refute exported_lobject_2['resource_type'].present?
        refute exported_lobject_2['standard'].present?
        refute exported_lobject_2['subject'].present?
      end

      protected

      def csv_path(file)
        Rails.root.join('test', 'fixtures', 'csvs', file).to_s
      end

      def generate_csv(filename, vars)
        namespace = OpenStruct.new(vars)
        contents = ERB
          .new(File.read(csv_path(filename)))
          .result(namespace.instance_eval { binding })
        tmpfile = Tempfile.new(filename)
        tmpfile.write(contents)
        tmpfile.close
        tmpfile.path
      end

      def navigate_to_import
        login_as users(:admin)
        visit '/lt/admin'
        click_link 'Import CSV'
        assert_equal '/lt/admin/csv_imports/new', current_path
      end

      def assert_resources_updated(lobject_1, lobject_2)
        # First resource should have all its fields updated.
        assert_equal 'http://npg.si.edu/',              lobject_1.url.url
        assert_equal 'Civil War Educational Resources', lobject_1.title
        assert_equal 'Lesson plans introduce history',  lobject_1.description

        assert_same_elements ['Smithsonian Education','Another Institution'],
          lobject_1
          .lobject_identities
          .select { |idt| idt.identity_type == 'publisher' }
          .map(&:identity)
          .map(&:name)

        assert_same_elements ['grade 1', 'grade 2', 'grade 3'],
          lobject_1.grades.map(&:grade)

        assert_same_elements ['lesson plan', 'textbook'],
          lobject_1.resource_types.map(&:name) 
          
        assert_same_elements ['ELA-Literacy.L.1.4a', 'ELA-Literacy.SL.4.1a', 'ELA-Literacy.W.K.8'],
          lobject_1.alignments.map(&:name) 
          
        assert_same_elements ['civil war', 'education'],
          lobject_1.subjects.map(&:name)

        # Second resource should have most of its fields cleared up.
        assert_equal 'http://gardens.si.edu', lobject_2.url.url
        assert_equal 'Bla: The Great Bla',    lobject_2.title
        assert_empty lobject_2.lobject_identities
        assert_empty lobject_2.grades
        assert_empty lobject_2.resource_types
        assert_empty lobject_2.alignments
        assert_empty lobject_2.subjects
        assert_nil   lobject_2.description
      end
    end
  end
end
