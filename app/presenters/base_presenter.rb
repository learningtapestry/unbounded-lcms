class BasePresenter < SimpleDelegator
  def t(key, options = {})
    class_name = self.class.to_s.underscore
    options[:raise] = true
    I18n.t("#{class_name}.#{key}", options)
  end
end
