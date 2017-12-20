# frozen_string_literal: true

class DownloadCategory < ActiveRecord::Base
  has_many :resource_downloads

  default_scope { order(:position) }

  acts_as_list

  validates :title, uniqueness: true, presence: true
end
