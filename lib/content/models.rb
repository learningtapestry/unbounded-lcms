require 'edge'
require 'will_paginate'
require 'will_paginate/active_record'

ActiveRecord::Base.raise_in_transactional_callbacks = true

Dir[File.join(__dir__, 'models', '**', '*.rb')].each { |model| require model }
