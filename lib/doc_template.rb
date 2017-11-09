# frozen_string_literal: true

module DocTemplate
  FULL_TAG = /\[([^\]:\s]*)?\s*:?\s*([^\]]*?)?\]/mo
  ROOT_XPATH = '*//'
  START_TAG = '\[[^\]]*'
  STARTTAG_XPATH = 'span[contains(., "[")]'
  ENDTAG_XPATH = 'span[contains(., "]")]'
end

require_dependency 'doc_template/template'
require_dependency 'doc_template/document'
require_dependency 'doc_template/tags'
require_dependency 'doc_template/document_toc'
require_dependency 'doc_template/xpath_functions'

Dir["#{__dir__}/doc_template/tables/*.rb"].each { |f| require_dependency f }
Dir["#{__dir__}/doc_template/tags/*.rb"].each { |f| require_dependency f }
Dir["#{__dir__}/doc_template/objects/*.rb"].each { |f| require_dependency f }
