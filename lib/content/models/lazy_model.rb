module Content
  class LazyModel < BasicObject
    attr_accessor :id
    attr_reader :lazy_class

    def initialize(lazy_class, model_id)
      @lazy_class = lazy_class
      self.id = model_id  
    end

    def method_missing(method, *args, &block)
      @loaded_model ||= @lazy_class.find(id)
      @loaded_model.send(method, *args, &block)
    end
  end
end
