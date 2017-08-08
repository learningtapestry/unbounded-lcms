# frozen_string_literal: true

class PreviewsMaterialSerializer < ActiveModel::Serializer
  self.root = false
  attributes :activity, :content_type, :data, :lesson, :subject
  attr_reader :document
  delegate :content_type, :subject, to: :document

  def initialize(props, document)
    super(document)
    @document = document
    @props = props
  end

  def activity
    {}.tap do |x|
      %w(title type).each { |m| x["activity_#{m}"] = @props['activity'].send(:[], m) }
    end
  end

  def data
    materials.map do |material|
      MaterialSerializer.new(
        MaterialPresenter.new material, lesson: @document
      ).as_json
    end
  end

  def lesson
    @lesson ||=
      {}.tap do |x|
        %i(grade ld_module subject title lesson).each { |m| x["lesson_#{m}"] = @document.send m }
        x['lesson_unit_topic'] = @document.topic
      end
  end

  private

  def materials
    @materials ||= Material.where(id: @props['material_ids'])
  end
end
