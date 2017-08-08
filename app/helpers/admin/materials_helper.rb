# frozen_string_literal: true

module Admin
  module MaterialsHelper
    def document_materials_links(lesson)
      lesson.materials.map { |m| link_to(m.identifier, m, target: '_blank') }.join(', ').html_safe
    end
  end
end
