require 'elasticsearch/dsl'

Elasticsearch::DSL::Search::BaseComponent.module_eval do
  def apply(object, method)
    object.instance_method(method).bind(self).call
  end
end
