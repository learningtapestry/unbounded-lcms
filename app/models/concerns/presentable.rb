require 'active_support/concern'

module Presentable
  extend ActiveSupport::Concern

  class_methods do
    def presenter_class
      @presenter_class ||= "#{name.demodulize}Presenter".constantize
    end
  end

  included do
    def presenter
      self.class.presenter_class.new self
    end
  end
end
