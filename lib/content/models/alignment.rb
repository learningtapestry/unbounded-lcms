require 'content/models/concerns/canonicable'

module Content
  module Models  
    class Alignment < ActiveRecord::Base
      include Canonicable

      validates :name, presence: true

      default_scope { order(:name) }
    end
  end
end
