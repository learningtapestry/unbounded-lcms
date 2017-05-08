module DocTemplate
  FULL_TAG = /\[([^\]:]*)?:?\s*([^\]]*)?\]/mo
  ROOT_XPATH = '*//'
  STARTTAG_XPATH = 'span[contains(., "[")]'
  ENDTAG_XPATH = 'span[contains(., "]")]'
end

require 'doc_template/template'
require 'doc_template/document'
require 'doc_template/meta_table'
require 'doc_template/tag'
require 'doc_template/toc'
require 'doc_template/xpath_functions'
require 'doc_template/activity_table'
require 'doc_template/agenda_table'

# Load all the tags
Dir["#{__dir__}/doc_template/tags/*.rb"].each { |f| require f }
# Load all the objects
Dir["#{__dir__}/doc_template/objects/*.rb"].each { |f| require f }
