class ContentGuideStandard < ActiveRecord::Base
  def self.import
    api_url = "#{ENV['COMMON_STANDARDS_PROJECT_API_URL']}/api/v1"
    auth_header = { 'Api-Key' => ENV['COMMON_STANDARDS_PROJECT_API_KEY'] }

    jurisdiction_id = ENV['COMMON_STANDARDS_PROJECT_JURISDICTION_ID']
    jurisdiction = JSON(RestClient.get("#{api_url}/jurisdictions/#{jurisdiction_id}", auth_header))

    jurisdiction['data']['standardSets'].each do |standard_set|
      standard_set_id = standard_set['id']
      standard_set_data = JSON(RestClient.get("#{api_url}/standard_sets/#{standard_set_id}", auth_header))['data']

      grade = standard_set_data['title']
      subject = standard_set_data['subject']

      standard_set_data['standards'].each do |standard_id, data|
        content_guide_standard = find_or_initialize_by(standard_id: standard_id)

        content_guide_standard.alt_statement_notation = data['altStatementNotation']
        content_guide_standard.asn_identifier = data['asnIdentifier']
        content_guide_standard.description = data['description']
        content_guide_standard.grade = grade
        content_guide_standard.statement_notation = data['statementNotation']
        content_guide_standard.subject = subject

        content_guide_standard.save!
      end
    end
  end
end
