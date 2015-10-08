module Unbounded
  module CurriculumHelper
    def cache_key_for_curriculum
      subject = params[:subject] || 'all'
      grade = params[:grade] || 'all'
      standards = params[:standards] || 'all'
      "curriculum/#{subject}/#{grade}/#{standards}"
    end

    def each_units(unit, &block)
      children = unit.children.each_slice(16).to_a
      unless children.empty?
        children.each_with_index(&block)
      else
        yield [], 1
      end
    end

    def each_with_module_class(modules)
      mod_classes = []

      is_first_item = true
      modules.each do |mod|
        klass = 'module-12'

        if fits_in_half?(mod)
          if is_first_item
            next_mod = next_module_node(mod)
            if next_mod && fits_in_half?(next_mod)
              mod_units, next_mod_units = module_node_ui_units(mod), module_node_ui_units(next_mod)
              both_empty = mod_units == 0 && next_mod_units == 0
              none_empty = mod_units > 0 && next_mod_units > 0
              klass = 'module-6' if (both_empty || none_empty) 
            end
          else
            klass = 'module-6' if fits_in_half?(previous_module_node(mod))
          end
        end

        is_first_item = !is_first_item if klass == 'module-6'
        mod_classes << [mod, klass]
      end

      mod_classes.each { |(mod, klass)| yield mod, klass }
    end

    def module_node_ui_units(module_node)
      module_node.children.inject(0) do |total, unit_node|
        grids = (unit_node.children.size/16.0).ceil
        grids = 1 if grids == 0
        total + grids
      end
    end

    def previous_module_node(module_node)
      grade_node = module_node.parent
      position = grade_node.children.index(module_node)
      if position > 0
        grade_node.children[position-1]
      else
        nil
      end
    end

    def next_module_node(module_node)
      grade_node = module_node.parent
      position = grade_node.children.index(module_node)
      grade_node.children[position+1]
    end

    def fits_in_half?(module_node)
      module_node_ui_units(module_node) <= 3
    end
  end
end
