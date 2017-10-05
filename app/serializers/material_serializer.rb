# frozen_string_literal: true

class MaterialSerializer < ActiveModel::Serializer
  self.root = false
  attributes :anchors, :id, :identifier, :orientation, :subtitle, :title, :thumb, :url, :gdoc
  delegate :anchors, :lesson, :orientation, :pdf_filename, :subtitle, :title, to: :object

  def thumb
    "#{s3_filename}.jpg"
  end

  def url
    "#{s3_filename}.pdf"
  end

  def gdoc
    URI.escape lesson.links['materials']&.dig(id.to_s)&.dig('gdoc').presence || ''
  end

  private

  def s3_filename
    URI.escape "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3.amazonaws.com/#{pdf_filename}"
  end
end
