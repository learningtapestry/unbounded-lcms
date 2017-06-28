module DocTemplate
  module Tags
    class DefaultTag < BaseTag
      TAG_NAME = 'default'.freeze
    end
  end

  Template.register_tag(Tags::DefaultTag::TAG_NAME, Tags::DefaultTag)
end
