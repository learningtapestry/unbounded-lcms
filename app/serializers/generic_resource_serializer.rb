class GenericResourceSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :subject, :teaser, :path, :instruction_type, :grade_avg

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def path
    generic_path(object)
  end

  def title
    presenter = GenericPresenter.new(object)
    return "#{presenter.grades_to_str} #{presenter.type_name}" unless object.grades.blank?
    presenter.type_name
  end

  def teaser
    object.title
  end

  def instruction_type
    :generic
  end
end
