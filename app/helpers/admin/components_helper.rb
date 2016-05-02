module Admin::ComponentsHelper
  def resource_picker_field(form, collection, path:, name:)
    path = path.to_s
    base_name = form.hidden_field(name).scan(/\b(?<=name=\")[^"]+(?=\")/)[0] 
    component = react_component('ResourcePicker',
      name: "#{base_name}[]",
      resources: collection.map { |i| { id: i.id, title: i.title } }
    )
    content_tag(:div) do
      [
        concat(content_tag(:label, path.titleize, for: path)),
        concat(content_tag(:div, component, id: path))
      ]
    end
  end

  def association_picker_field(form, collection, path:, name:, allow_create: false, create_name: nil, allow_multiple: true)
    path = path.to_s
    collection = collection ? Array.wrap(collection) : []

    scoped_name = form.hidden_field(name).scan(/\b(?<=name=\")[^"]+(?=\")/)[0]

    if create_name
      scoped_create_name = scoped_name.gsub(name.to_s, create_name.to_s)
    end

    component = react_component('AssociationPicker',
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
end
