# import standards emphasis from csv spreadsheet
class EmphasisImporter
  attr_reader :csv_filepath

  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
  end

  def run!
    CSV.foreach(csv_filepath, headers: true) do |row|
      grade = get_grade(row)

      standard = find_standard row['Standards:']
      StandardEmphasis.find_or_create_by(
        standard: standard,
        emphasis: emphasis(row['Standard Emphasis:']),
        grade: grade
      )

      cluster = find_cluster row['Cluster:']
      StandardEmphasis.find_or_create_by(
        standard: cluster,
        emphasis: emphasis(row['Cluster Emphasis:']),
        grade: grade
      )
    end
  end

  def emphasis(emp)
    if emp == '+'
      'plus'
    else
      emp.downcase
    end
  end

  def get_grade(row)
    grades_map[row['Course (HS Only)']]
  end

  def grades_map
    @grade_map ||= {
      'Algebra I'   => 'grade 9',
      'Geometry'    => 'grade 10',
      'Algebra II'  => 'grade 11',
      'Precalculus' => 'grade 12',
    }
  end

  def find_standard(std)
    std = std.downcase
    Standard.where("name = ? OR alt_names @> ?", std, "{#{std}}").first
  end

  def find_cluster(std)
    std = std.downcase
    CommonCoreStandard.clusters.where("name = ? OR alt_names @> ?", std, "{#{std}}").first
  end
end
