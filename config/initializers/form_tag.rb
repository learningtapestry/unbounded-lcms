module ActionView
  module Helpers
    module FormTagHelper
      alias_method :orig_form_tag, :form_tag
      def form_tag(url_for_options = {}, options = {}, &block)
        options[:enforce_utf8] = false
        orig_form_tag(url_for_options, options, &block)
      end
    end
  end
end
