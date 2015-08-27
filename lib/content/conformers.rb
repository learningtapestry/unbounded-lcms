Dir[File.join(__dir__, 'conformers', '**', '*.rb')].each { |model| require model }
