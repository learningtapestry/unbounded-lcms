class Standard < ActiveRecord::Base
  has_many :resource_standards
  belongs_to :standard_cluster
  belongs_to :standard_domain
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
        subject = standard_set_data['subject']

        standard_set_data['standards'].select do |_, data|
          asn_identifier = data['asnIdentifier'].downcase
          name = data['statementNotation'].try(:downcase)
          
          standard = name.present? ? find_or_initialize_by(name: name) : find_or_initialize_by(asn_identifier: asn_identifier)

          standard.alt_name = data['altStatementNotation'].try(:downcase)
          standard.asn_identifier = asn_identifier
          standard.description = data['description']
          standard.grades << grade unless standard.grades.include?(grade)
          standard.label = data['statementLabel']
          standard.name = name
          standard.subject = subject

          standard.save!
        end
      end
    end
  end
end
