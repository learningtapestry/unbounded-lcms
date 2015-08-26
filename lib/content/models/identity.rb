require 'content/models/concerns/canonicable'

module Content
  class Identity < ActiveRecord::Base
    include Canonicable
  end
end
