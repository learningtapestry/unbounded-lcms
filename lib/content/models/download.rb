require 'content/models/concerns/canonicable'

module Content
  module Models
    class Download < ActiveRecord::Base
      include Canonicable
    end
  end
end
