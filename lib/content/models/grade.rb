require 'content/models/concerns/canonicable'
require 'content/models/concerns/normalizable'

module Content
  class Grade < ActiveRecord::Base
    include Canonicable
    include Normalizable
    normalize_attr :grade, ->(val) { val.strip.downcase }
  end
end
