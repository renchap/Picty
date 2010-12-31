class Picture
  attr_reader :filename, :directory
  
  class NotFound < Exception
  end

  def initialize(path)
    
    ar = path.split('/')
    
    # Filename is the last part
    @filename = ar.pop
    
    begin
      @directory = Directory.get_directory("/#{ar.join('/')}")
    rescue Directory::NotFound => e
      # Picture not found if directory is not found
      raise Picture::NotFound, "Directory for picture #{path} not found"
    end
    
    # Picture not found if the picture does not exists on disk
    raise Picture::NotFound, "Picture #{path} not found" unless File.file?(self.physical_path)
  end
  
  def to_param
    self.path[1..-1].gsub(/\.jpg/i,'')
  end

  def self.from_param(param)
    begin
      Picture.new(param.join('/')+'.jpg')
    rescue Picture::NotFound => e
      nil
    end
  end

  def path
    self.directory.path+'/'+self.filename
  end
  
  def physical_path
    Padrino.root("public/pictures#{self.path}")
  end
  
  def url
    "/pictures#{self.path}"
  end

  def thumbnail
    @thumbnail = Thumbnail.new(self) unless @thumbnail
    @thumbnail
  end
end
