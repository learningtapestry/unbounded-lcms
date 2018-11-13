# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    Material.module_eval do
      def vertical_text
        document.metadata.vertical_text
      end
    end
  end
end