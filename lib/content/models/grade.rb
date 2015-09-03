require 'content/models/concerns/canonicable'
require 'content/models/concerns/normalizable'

module Content
  module Models
    class Grade < ActiveRecord::Base
      include Canonicable
      include Normalizable
      normalize_attr :grade, ->(val) { val.strip.downcase }

      default_scope { order(:grade) }
    end
  end
end
