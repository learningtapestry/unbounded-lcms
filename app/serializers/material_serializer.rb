# frozen_string_literal: true

class MaterialSerializer < ActiveModel::Serializer
  self.root = false
  attributes :anchors, :id, :identifier, :gdoc_url, :orientation, :pdf_url, :source_type, :subtitle, :title, :thumb_url
  delegate :anchors, :gdoc_url, :lesson, :orientation, :pdf_url, :source_type, :subtitle, :title, :thumb_url, to: :object
end
