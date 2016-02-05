class SubtitlesImporter
  include ActiveModel::Model

  MIN_COLUMNS_COUNT = 5
  DESCRIPTION_INDEX = 4
  ID_INDEX          = 1
  SUBTITLE_INDEX    = 3

  attr_accessor :file, :resources

  validates :file, presence: true
  validate :spreadsheet_format

  def initialize(file = nil)
    @file = file
    if @file.present?
      @doc = Roo::Spreadsheet.open(file.path) rescue nil
    end
  end

  def import
    if valid?
      sheet = Roo::Spreadsheet.open(file.path)

      @resources = []

      (2..sheet.last_row).each do |i|
        row = sheet.row(i)
        description = row[DESCRIPTION_INDEX]
        subtitle = row[SUBTITLE_INDEX]
        if description.present? || subtitle.present?
          if (resource = Resource.find_by_id(row[ID_INDEX])).present?
            if description.present?
              resource.update_attribute(:description, description)
            end

            if subtitle.present?
              resource.update_attribute(:subtitle, subtitle)
            end

            @resources << resource
          end
        end
      end
    end
  end

  private
    def spreadsheet_format
      return if file.blank?

      if @doc
        cols_count = @doc.row(1).size
        errors.add(:file, :incorrect_format, count: cols_count, limit: MIN_COLUMNS_COUNT) if cols_count < MIN_COLUMNS_COUNT
      else
        errors.add(:file, :incorrect_type)
      end
    end
end
