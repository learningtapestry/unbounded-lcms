module DocTemplate
  class DefaultTag < Tag
  end

  Template.register_tag('default'.freeze, DefaultTag)
end
