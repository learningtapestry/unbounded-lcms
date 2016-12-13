# import bilingual standards from csv spreadsheet
class BilingualStandardsImporter
  attr_reader :csv_filepath, :files_dir

  def initialize(csv_filepath, files_dir)
    @csv_filepath = csv_filepath
    @files_dir = files_dir
  end

  def run!
    not_found = []
    CSV.foreach(csv_filepath, headers: true) do |row|
      (row['Standard'] || '').split(',').each do |std|
        orig_std = std.strip
        print "#{orig_std}\t"
        std = std.gsub('-','.').gsub(' ', '')
        found = find_standard(std)
        not_found << orig_std unless found
        print "-> #{found.try(:name)}\n"
      end
      # resource_type = row['resource_type'].gsub(' ', '_').underscore

      # resource = Resource.create(
      #   title: row['title'],
      #   teaser: row['teaser'],
      #   resource_type: Resource.resource_types[resource_type],
      #   description: row['description'],
      #   subject: row['subject'].downcase
      # )

      # filename = row['file_name']
      # find_files(filename).each do |path|
      #   download = Download.create(file: File.open(path), title: filename, main: path.end_with?('.pdf'))
      #   resource.downloads << download
      # end


      # resource.save
      # puts "-- imported: id=#{resource.id} title=#{resource.title}"
    end
    puts "\n\n================"
    puts "#{not_found.count} NOT FOUND!"
    puts not_found
  end

  def find_standard(std)
    std = std.downcase
    Standard.where("name = ? OR alt_names @> ?", std, "{#{std}}").first
  end

  def find_files(filename)
    Dir[File.join(files_dir, '**', '*.{pdf,docx}')].select { |f| f =~ /#{filename}/ }
  end
end
