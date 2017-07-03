class CommonCoreStandard < Standard
  belongs_to :standard_strand
  belongs_to :cluster, class_name: 'CommonCoreStandard'
  belongs_to :domain, class_name: 'CommonCoreStandard'

  scope :clusters, -> { where(label: 'cluster') }
  scope :domains, -> { where(label: 'domain') }
  scope :standards, -> { where(label: 'standard') }

  def self.find_by_name_or_synonym(name)
    name = name.downcase
    find_by_name(name) || where_alt_name(name).first
  end

  def self.where_alt_name(alt_name)
    where('? = ANY(alt_names)', alt_name)
  end

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

          std_params = name.present? ? { name: name } : { asn_identifier: asn_identifier }
          standard = find_or_initialize_by(**std_params)

          standard.generate_alt_names

          if (alt_name = data['altStatementNotation'].try(:downcase))
            standard.alt_names << alt_name unless standard.alt_names.include?(alt_name)
          end

          standard.asn_identifier = asn_identifier
          standard.description = data['description']
          standard.grades << grade unless standard.grades.include?(grade)
          standard.label = data['statementLabel'].try(:downcase)
          standard.name = name if name.present?
          standard.subject = subject

          standard.save!
        end
      end
    end
  end

  def generate_alt_names(regenerate: false)
    return unless name

    alt_names = Set.new

    # ccss.ela-literacy.1.2 -> 1.2
    short_name = name
                   .gsub('ccss.ela-literacy.', '')
                   .gsub('ccss.math.content.', '')
                   .gsub('ccss.math.practice.', '')

    base_names = Set.new([short_name, short_name.gsub('ccra', 'ra')])

    if short_name.starts_with?('hs')
      # hsn-rn.b.3 -> n-rn.b.3
      base_names << short_name.gsub('hs', '')
    end

    base_names.each do |base_name|
      # 6.rp.a.3a -> 6.rp.a.3.a
      letters_expand = base_name.gsub(/\.([1-9])([a-z])$/, '.\1.\2')

      # 6-rp.a.3 -> 6.rp.a.3
      dot_name = base_name.gsub(/[-]/, '.')

      # ccss.ela-literacy.r.1.2 -> ela.r.1.2
      prefixed_dot_name = "#{subject}.#{dot_name}"

      if name.include?('math') && dot_name.count('.') == 3
        # 5.oa.b.3 -> 5.oa.3
        # n.rn.b.3 -> n.rn.3
        without_cluster = dot_name.split('.').values_at(0, 1, 3).join('.')
        alt_names << without_cluster
      end

      alt_names << base_name
      alt_names << letters_expand
      alt_names << dot_name
      alt_names << prefixed_dot_name
    end

    # add "clean" names: ela.r.1.2 -> elar12
    alt_names.merge(alt_names.map { |n| n.gsub(/[\.-]/, '') })

    alt_names.merge(self.alt_names) unless regenerate

    self.alt_names = alt_names.to_a
  end
end
