module FilesLoader
  def self.load!(basedir, module_extension=nil)
    Loader.new(basedir, module_extension).load!
  end
end
