# import standards emphasis from csv spreadsheet
class EmphasisImporter
  attr_reader :csv_filepath

  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
  end

  def run!
    CSV.foreach(csv_filepath, headers: true) do |row|
      standard = find_standard row['Standards:']
      cluster  = find_cluster  row['Cluster:']

      if emphasis(cluster) != row['Cluster Emphasis:']
        puts "Cluster #{row['Cluster:']} emphasis do not match: db=#{emphasis(cluster)} csv=#{row['Cluster Emphasis:']}"
      end

      if emphasis(standard) != row['Standard Emphasis:']
        puts "Srandard #{row['Standards:']} emphasis do not match: db=#{emphasis(standard)} csv=#{row['Standard Emphasis:']}"
      end

      # cluster.update_attributes emphasis: row['Cluster Emphasis:']
      # standard.update_attributes emphasis: row['Standard Emphasis:']
      #
    end
  end

  def emphasis(std)
    std.emphasis.try(:upcase).try(:gsub, 'PLUS', '+')
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
