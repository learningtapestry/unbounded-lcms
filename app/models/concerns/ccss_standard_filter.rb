module CCSSStandardFilter
  extend ActiveSupport::Concern

  ALT_NAME_REGEX = {
    'ela' => /^[[:alpha:]]+\.(k|pk|\d+)\.\d+(\.[[:alnum:]]+)?$/,
    'math' => /^(k|pk|\d+)\.[[:alpha:]]+(\.[[:alpha:]]+)?\.\d+(\.[[:alpha:]]+)?$/
  }.freeze

  included do
    def filter_ccss_standards(name)
      name.upcase if name =~ (ALT_NAME_REGEX[subject] || /.*/)
    end
  end
end
