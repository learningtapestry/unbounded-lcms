Dir[File.join(__dir__, 'format_parsers', '**', '*.rb')].each { |model| require model }
