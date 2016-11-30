class GenericPresenter < ResourcePresenter
  def generic_title
    "#{subject.try(:upcase)} #{grades.try(:first).try(:name)}"
  end

  def type_name
    resource_type.humanize
  end
end
