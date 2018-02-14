# frozen_string_literal: true

module Admin
  module ComponentsHelper
    def resource_picker_field(form, collection, allow_multiple: true, path:, name:)
      path = path.to_s

      base_name = form.hidden_field(name).scan(/\b(?<=name=\")[^"]+(?=\")/)[0]
      computed_name = "#{base_name}[]"

      component = react_component(
        'ResourcePicker',
        name: computed_name,
        resources: collection.map { |i| { id: i.id, title: i.title } },
        allow_multiple: allow_multiple
      )
      content_tag(:div) do
        [
          concat(content_tag(:label, path.titleize, for: path)),
          concat(content_tag(:div, component, id: path))
        ]
      end
    end

    # rubocop:disable Metrics/ParameterLists
    def association_picker_field(form, collection, path:, name:, allow_create: false,
                                 create_name: nil, allow_multiple: true)
      path = path.to_s
      collection = collection ? Array.wrap(collection) : []

      scoped_name = form.hidden_field(name).scan(/\b(?<=name=\")[^"]+(?=\")/)[0]

      if create_name
        scoped_create_name = scoped_name.gsub(name.to_s, create_name.to_s)
      end

      component = react_component(
        'AssociationPicker',
        name: scoped_name,
        create_name: scoped_create_name,
        association: path,
        items: collection.map { |i| { id: i.id, name: i.name } },
        allow_create: allow_create,
        allow_multiple: allow_multiple
      )
      content_tag(:div) do
        [
          concat(content_tag(:label, path.titleize, for: path)),
          concat(content_tag(:div, component, id: path))
        ]
      end
    end
    # rubocop:enable Metrics/ParameterLists

    def curriculum_picker_props(resource)
      {
        directory: resource.curriculum_directory,
        parent: {
          curriculum: resource.parent.try(:curriculum) || [],
          id: resource.parent_id,
          title: resource.parent.try(:title)
        },
        tree: CurriculumPresenter.new.editor_props[:tree]
      }
    end
  end
end
