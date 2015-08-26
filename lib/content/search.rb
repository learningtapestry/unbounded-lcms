Dir[File.join(__dir__, 'search', '**', '*.rb')].each { |model| require model }
