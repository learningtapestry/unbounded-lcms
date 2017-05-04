module DocTemplate
  FULL_TAG = /\[([^]:]*)?:?\s*([^]]*)?]/mo
  ROOT_XPATH = '*//'
  STARTTAG_XPATH = 'span[contains(., "[")]'
  ENDTAG_XPATH = 'span[contains(., "]")]'
end

require 'doc_template/template'
require 'doc_template/document'
require 'doc_template/meta_table'
require 'doc_template/tag'

# Load all the tags
Dir["#{__dir__}/doc_template/tags/*.rb"].each { |f| require f }
