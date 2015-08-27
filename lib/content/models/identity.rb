require 'content/models/concerns/canonicable'

module Content
  module Models
    class Identity < ActiveRecord::Base
      include Canonicable
    end
  end
end
