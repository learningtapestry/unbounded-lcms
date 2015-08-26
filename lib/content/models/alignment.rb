require 'content/models/concerns/canonicable'

module Content  
  class Alignment < ActiveRecord::Base
    include Canonicable
  end
end
