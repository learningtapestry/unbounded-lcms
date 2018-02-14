# frozen_string_literal: true

class ResourceStandard < ActiveRecord::Base
  belongs_to :resource
  belongs_to :standard
end
