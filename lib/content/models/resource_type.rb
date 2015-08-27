require 'content/models/concerns/canonicable'
require 'content/models/concerns/normalizable'

module Content
  module Models
    class ResourceType < ActiveRecord::Base
      include Canonicable
      include Normalizable
      normalize_attr :name, ->(val) { val.strip.downcase }
    end
  end
end
