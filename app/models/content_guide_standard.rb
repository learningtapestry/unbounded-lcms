# frozen_string_literal: true

class ContentGuideStandard < ActiveRecord::Base
  belongs_to :content_guide
  belongs_to :standard
end
