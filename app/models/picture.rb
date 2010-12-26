class Picture
  attr_reader :filename, :directory
  
  def initialize(path)
    
    ar = path.split('/')
    
    @filename = ar.pop
    @directory = Directory.get_directory("/#{ar.join('/')}")
  end
  
  def path
    self.directory.path+'/'+self.filename
  end
  
  def physical_path
    "#{PADRINO_ROOT}/public/pictures#{self.path}"
  end
  
  def url
    "/pictures#{self.path}"
  end
  
  def thumbnail
    @thumbnail = Thumbnail.new(self) unless @thumbnail
    @thumbnail
  end
end