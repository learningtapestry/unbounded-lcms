# import bilingual standards from csv spreadsheet
class BilingualStandardsImporter
  attr_reader :csv_filepath, :files_dir

  def initialize(csv_filepath, files_dir)
    @csv_filepath = csv_filepath
    @files_dir = files_dir
  end

  def run!
    CSV.foreach(csv_filepath, headers: true) do |row|
      standards(row).each do |std|
        standard = find_standard clean_name(std)

        if standard
          standard.file = File.open file_path(row)
          standard.is_language_progression_standard = true
          standard.save!

          puts "-- Standard imported : #{row['Standard']}"
        end
      end
    end
  end

  def standards(row)
    (row['Standard'] || '').split(',')
  end

  def clean_name(std)
    std.strip.gsub('-','.').gsub(' ', '')
  end

  def file_path(row)
    File.join(files_dir, row['Filename'])
  end

  def find_standard(std)
    std = std.downcase
    Standard.where("name = ? OR alt_names @> ?", std, "{#{std}}").first
  end

  def find_files(filename)
    Dir[File.join(files_dir, '**', '*.{pdf,docx}')].select { |f| f =~ /#{filename}/ }
  end
end
