class Directory
  attr_reader :path, :name
  @@directories = Hash.new
  
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
  end
  
  def physical_path
    "#{PADRINO_ROOT}/public/pictures#{self.path}"
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
  
  def images
    Dir.entries(self.physical_path).reject do |entry|
      next true if entry =~ /^\./
      next true unless File.file?(self.physical_path+'/'+entry)
      not entry =~ /\.jpg$/i
    end
  end
  
  def number_of_images
    self.images.length
  end
end