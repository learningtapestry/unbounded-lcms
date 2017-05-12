module DocTemplate
  FULL_TAG = /\[([^\]:]*)?:?\s*([^\]]*)?\]/mo
  ROOT_XPATH = '*//'
  STARTTAG_XPATH = 'span[contains(., "[")]'
  ENDTAG_XPATH = 'span[contains(., "]")]'
end

require_dependency 'doc_template/template'
require_dependency 'doc_template/document'
require_dependency 'doc_template/meta_table'
require_dependency 'doc_template/tags'
require_dependency 'doc_template/document_toc'
require_dependency 'doc_template/xpath_functions'
require_dependency 'doc_template/activity_table'
require_dependency 'doc_template/agenda_table'

# Load all the tags
Dir["#{__dir__}/doc_template/tags/*.rb"].each { |f| require_dependency f }
# Load all the objects
Dir["#{__dir__}/doc_template/objects/*.rb"].each { |f| require_dependency f }
