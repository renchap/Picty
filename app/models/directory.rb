class Directory
  attr_reader :path, :name
  @@directories = Hash.new
  
  class NotFound < Exception
  end

  def self.get_directory(path)
    path.gsub!(/\/+/,'/')
    dir = @@directories[path]
    unless dir
      dir = Directory.new(path)
      @@directories[path] = dir
    end 
    dir
  end
  
  def initialize(path)
    # Remove duplicate /
    path.gsub!(/\/+/,'/')
    @path = path
    @name = path.split('/').pop
    raise Directory::NotFound.new("Directory #{path} does not exists") unless File.directory?(self.physical_path)
  end
  
  def to_param
    self.path[1..-1]
  end
  
  def self.from_param param
    begin
      Directory.get_directory('/'+param.join('/'))
    rescue Directory::NotFound => e
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
      Directory.get_directory("#{self.path}/#{subdir}")
    end
  end
  
  def parent
    return nil if @path == '/'
    a = self.path.split('/')
    a.pop
    Directory.get_directory '/'+a.join('/')
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
