class Album
  attr_reader :path, :name
  @@albums = Hash.new
  
  class NotFound < Exception
  end

  def self.get_album(path)
    path.gsub!(/\/+/,'/')
    album = @@albums[path]
    unless album
      album = Album.new(path)
      @@albums[path] = album
    end 
    album
  end
  
  def initialize(path)
    # Remove duplicate /
    path.gsub!(/\/+/,'/')
    @path = path
    @name = path.split('/').pop
    raise Album::NotFound.new("Directory #{path} does not exists") unless File.directory?(self.physical_path)
  end
  
  def to_param
    self.path[1..-1]
  end
  
  def self.from_param param
    begin
      Album.get_album('/'+param.join('/'))
    rescue Album::NotFound => e
      nil
    end
  end
  
  def physical_path
    Padrino.root("public/pictures#{self.path}")
  end
  
  def children
    Dir.entries(self.physical_path).reject do |entry|
      next true if entry =~ /^\./
      not File.directory?(self.physical_path+'/'+entry)
    end.map do |subdir|
      Album.get_album("#{self.path}/#{subdir}")
    end
  end
  
  def parent
    return nil if @path == '/'
    a = self.path.split('/')
    a.pop
    Album.get_album '/'+a.join('/')
  end
  
  def pictures
    Dir.entries(self.physical_path).reject do |entry|
      next true if entry =~ /^\./
      next true unless File.file?(self.physical_path+'/'+entry)
      not entry =~ /\.jpg$/i
    end.map do |picture|
      Picture.new("#{self.path}/#{picture}")
    end
  end
  
  def number_of_pictures
    self.pictures.length
  end
end
