module DocTemplate
  FULL_TAG = /\[([^\]:]*)?:?\s*([^\]]*)?\]/mo
  ROOT_XPATH = '*//'.freeze
  STARTTAG_XPATH = 'span[contains(., "[")]'.freeze
  ENDTAG_XPATH = 'span[contains(., "]")]'.freeze
end

require_dependency 'doc_template/template'
require_dependency 'doc_template/document'
require_dependency 'doc_template/tags'
require_dependency 'doc_template/document_toc'
require_dependency 'doc_template/xpath_functions'

Dir["#{__dir__}/doc_template/tables/*.rb"].each { |f| require_dependency f }
Dir["#{__dir__}/doc_template/tags/*.rb"].each { |f| require_dependency f }
Dir["#{__dir__}/doc_template/objects/*.rb"].each { |f| require_dependency f }
