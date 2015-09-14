require 'elasticsearch/dsl'

Elasticsearch::DSL::Search::BaseComponent.module_eval do
  def module_call(_module, method)
    _module.instance_method(method).bind(self).call
  end
end
