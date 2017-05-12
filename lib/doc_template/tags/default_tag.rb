module DocTemplate
  module Tags
    class DefaultTag < BaseTag; end
  end

  Template.register_tag('default'.freeze, Tags::DefaultTag)
end
