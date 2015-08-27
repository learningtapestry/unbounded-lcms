require 'content/models/concerns/canonicable'

module Content
  module Models  
    class Alignment < ActiveRecord::Base
      include Canonicable
    end
  end
end
