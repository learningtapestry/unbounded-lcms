module Content
  module Models
    module Normalizable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def normalize_attr(attr_name, callable)
          normalize_method_name = "normalize_#{attr_name.to_s}"

          define_singleton_method normalize_method_name, &callable

          define_method "#{attr_name.to_s}=" do |value|
            normalized = self.class.send(normalize_method_name, value)
            write_attribute(attr_name, normalized)
          end
        end
      end
    end
  end
end
