class Standard < ActiveRecord::Base
  has_many :resource_standards
  belongs_to :standard_strand

  scope :by_grade, ->(grade) {
    self.by_grades([grade])
  }

  scope :by_grades, ->(grades) {
    joins(resource_standards: { resource: [:grades] }).where(
      'grades.id' => grades.map(&:id)
    )
  }

  scope :by_collection, ->(collection) {
    self.by_collection([collection])
  }

  scope :by_collections, ->(collections) {
    joins(resource_standards: { resource: [:resource_children] }).where(
      'resource_children.resource_collection_id' => collections.map(&:id)
    )
  }

  scope :ela, ->{ where(subject: 'ela') }
  scope :math, ->{ where(subject: 'math') }

  def self.import
    api_url = "#{ENV['COMMON_STANDARDS_PROJECT_API_URL']}/api/v1"
    auth_header = { 'Api-Key' => ENV['COMMON_STANDARDS_PROJECT_API_KEY'] }

    jurisdiction_id = ENV['COMMON_STANDARDS_PROJECT_JURISDICTION_ID']
    jurisdiction = JSON(RestClient.get("#{api_url}/jurisdictions/#{jurisdiction_id}", auth_header))

    Standard.transaction do
      jurisdiction['data']['standardSets'].map do |standard_set|
        standard_set_id = standard_set['id']
        standard_set_data = JSON(RestClient.get("#{api_url}/standard_sets/#{standard_set_id}", auth_header))['data']

        grade = standard_set_data['title'].downcase
        subject = standard_set_data['subject'] == 'Common Core English/Language Arts' ? 'ela' : 'math'

        standard_set_data['standards'].select do |_, data|
          asn_identifier = data['asnIdentifier'].downcase
          name = data['statementNotation'].try(:downcase)
          
          standard = name.present? ? find_or_initialize_by(name: name) : find_or_initialize_by(asn_identifier: asn_identifier)

          standard.generate_alt_names

          if alt_name = data['altStatementNotation'].try(:downcase)
            standard.alt_names << alt_name unless standard.alt_names.include?(alt_name)
          end

          standard.asn_identifier = asn_identifier
          standard.description = data['description']
          standard.grades << grade unless standard.grades.include?(grade)
          standard.label = data['statementLabel'].try(:downcase)
          standard.name = name
          standard.subject = subject

          standard.save!
        end
      end
    end
  end

  def generate_alt_names
    return unless name

    alt_names = []

    # ccss.ela-literacy.1.2 -> 1.2
    short_name = name
      .gsub('ccss.ela-literacy.', '')
      .gsub('ccss.math.content.', '')

    # 6.rp.a.3a -> 6.rp.a.3.a
    letters_expand = short_name.gsub(/\.([1-9])([a-z])$/, '.\1.\2')

    # 6.rp.a.3 -> 6rpa3
    clean_name = short_name.gsub(/[\.-]/, '')

    alt_names << short_name
    alt_names << clean_name
    alt_names << letters_expand

    self.alt_names = (self.alt_names + alt_names).uniq
  end
end
