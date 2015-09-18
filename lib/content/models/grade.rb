require 'content/models/concerns/canonicable'
require 'content/models/concerns/normalizable'

module Content
  module Models
    class Grade < ActiveRecord::Base
      include Canonicable
      include Normalizable
      normalize_attr :grade, ->(val) { val.strip.downcase }

      validates :name, presence: true

      default_scope { order(:grade) }

      alias_attribute :name, :grade
    end
  end
end
