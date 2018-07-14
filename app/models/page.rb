# frozen_string_literal: true

class Page < ActiveRecord::Base
  validates :body, :title, :slug, presence: true

  def full_title
    "LCMS - #{title}"
  end
end
