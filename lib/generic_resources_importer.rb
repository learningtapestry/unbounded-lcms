# import generic resources from csv spreadsheet
class GenericResourcesImporter
  attr_reader :csv_filepath, :files_dir

  def initialize(csv_filepath, files_dir)
    @csv_filepath = csv_filepath
    @files_dir = files_dir
  end

  def run!
    CSV.foreach(csv_filepath, headers: true) do |row|
      resource_type = row['resource_type'].gsub(' ', '_').underscore

      resource = Resource.create(
        title: row['title'],
        teaser: row['teaser'],
        resource_type: Resource.resource_types[resource_type],
        description: row['description'],
        subject: row['subject'].downcase
      )
      grades_for(row['grades']).each { |grade| resource.grade_list.add(grade) }

      filename = row['file_name']
      find_files(filename).each do |path|
        download = Download.create(file: File.open(path), title: filename, main: path.end_with?('.pdf'))
        resource.downloads << download
      end

      resource.copyright_attributions.create(value: row['attribution']) if row['attribution'].present?

      resource.save
      puts "-- imported: id=#{resource.id} title=#{resource.title}"
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
    Dir[File.join(files_dir, '**/*.{pdf,docx}')].select { |f| f =~ /#{filename}/ }
  end
end
