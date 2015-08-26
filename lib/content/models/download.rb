require 'content/models/concerns/canonicable'

module Content
  class Download < ActiveRecord::Base
    include Canonicable
  end
end
