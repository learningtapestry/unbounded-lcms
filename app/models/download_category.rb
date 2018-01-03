# frozen_string_literal: true

class DownloadCategory < ActiveRecord::Base
  has_many :resource_downloads

  default_scope { order(:position) }

  acts_as_list

  validates :title, uniqueness: true, presence: true

  before_save :unique_bundle

  def self.bundle
    where(bundle: true).first
  end

  private

  def unique_bundle
    self.class.where.not(id: id).where(bundle: true).update_all(bundle: false) if bundle_changed? && bundle?
  end
end
