# frozen_string_literal: true

class PreviewsMaterialSerializer < ActiveModel::Serializer
  self.root = false
  attributes :data, :pdf_type, :subject
  attr_reader :document
  delegate :pdf_type, :subject, to: :document

  def initialize(material_ids, document)
    super(document)
    @document = document
    @materials = Material.where(id: material_ids)
  end

  def data
    @materials.map do |material|
      MaterialSerializer.new(
        MaterialPresenter.new material, lesson: @document
      ).as_json
    end
  end
end
