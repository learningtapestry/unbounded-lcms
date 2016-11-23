# import generic resources from csv spreadsheet
class GenericResourcesImporter
  attr_reader :csv_filepath, :files_dir

  def initialize(csv_filepath, files_dir)
    @csv_filepath = csv_filepath
    @files_dir = files_dir
  end

  def run!
    CSV.foreach(csv_filepath, headers: true) do |row|
      resource = Resource.new(
        title: row['Title'],
        teaser: row['Teaser'],
        resource_type: Resource.resource_types[row['Resource Type'].underscore],
        description: row['Description'],
        subject: row['Subject'].downcase
      )
      # grades_for(row['Grade(s ']).each { |grade| resource.grades.add(grade) }
      files = find_files(row['File Name'])

      puts "==> #{row['Title']}  #{row['Grade(s ']} => #{grades_for(row['Grade(s '])}"
      puts files
    end
  end

  def grades_for(col)
    indices = col.downcase.gsub(' ', '').split('-').map {|g| grade_codes.index(g) }
    grade_codes[indices.first..indices.last].map { |g| grade_tag(g) }
  rescue
    byebug
  end

  def grade_codes
    @@grade_codes ||= %w(pk k 1 2 3 4 5 6 7 8 9 10 11 12)
  end

  def grade_tag(g)
    if g == 'pk'
      'prekindergarten'
    elsif g == 'k'
      'kindergarten'
    else
      "grade #{g}"
    end
  end

  def find_files(filename)
    Dir[files_dir + '**/*.{pdf,docx}'].select { |f| f =~ /#{filename}/ }
  end
end
