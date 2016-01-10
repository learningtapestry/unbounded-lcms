require 'content/exporters/excel_exporter'
require 'test_helper'

class ExcelExporterTestCase < TestCase
  include Content::Exporters
  include Content::Models

  def test_all_grades
    exporter = ExcelExporter.new
    data = exporter.export

    stream = StringIO.new
    stream.write(data)

    sheet = Roo::Excelx.new(stream)
    assert_equal ['ID Unbounded Database', 'ID Our Database', 'Title', 'Subtitle', 'Description', 'URL', 'Grades', 'Standards', 'Resource Types', 'Subjects'], sheet.row(1)
    (2..sheet.last_row).each do |i|
      id = sheet.cell(i, 2)
      lobject = Lobject.find_by_id(id)
      assert lobject
      assert_equal lobject.title, sheet.cell(i, 3)
      assert_equal lobject.subtitle, sheet.cell(i, 4)
      assert_equal lobject.text_description, sheet.cell(i, 5)
      assert_equal "https://content-staging.learningtapestry.com/resources/#{lobject.id}", sheet.cell(i, 6)
      assert_equal lobject.grades.map(&:grade).join(', '), sheet.cell(i, 7)
      assert_equal lobject.alignments.map(&:name).join(', '), sheet.cell(i, 8)
      assert_equal lobject.resource_types.map(&:name).join(', '), sheet.cell(i, 9)
      assert_equal lobject.subjects.map(&:name).join(', '), sheet.cell(i, 10)
    end
  end

  def test_grade1
    grade1 = Grade.find_by_grade('grade 1')
    exporter = ExcelExporter.new([grade1.id])
    data = exporter.export

    stream = StringIO.new
    stream.write(data)

    sheet = Roo::Excelx.new(stream)
    (2..sheet.last_row).each do |i|
      assert_includes 'grade 1', sheet.cell(i, 7)
    end
  end
end
