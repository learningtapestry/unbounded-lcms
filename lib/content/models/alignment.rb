require 'content/models/concerns/canonicable'

module Content
  module Models  
    class Alignment < ActiveRecord::Base
      include Canonicable

      default_scope { order(:name) }
    end
  end
end
