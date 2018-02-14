# frozen_string_literal: true

module DocTemplate
  module Tags
    class DefaultTag < BaseTag
      TAG_NAME = 'default'
    end
  end

  Template.register_tag(Tags::DefaultTag::TAG_NAME, Tags::DefaultTag)
end
