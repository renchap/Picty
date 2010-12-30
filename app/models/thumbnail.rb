class Thumbnail
  
  def initialize picture
    @picture = picture
  end
  
  def to_param
    @picture.to_param
  end

  def self.from_param param
    begin
      Picture.new('/'+param.join('/')).thumbnail
    rescue Picture::NotFound => e
      nil
    end
  end

  def physical_path
    "#{PADRINO_ROOT}/public/thumbs#{@picture.path}"
  end
  
  def url
    "/thumbs#{@picture.path}"
  end
  
  def create!
    image = MiniMagick::Image.open(@picture.physical_path)
    image.resize('200x200')
    # Create the directories if needed
    directory = self.physical_path.split('/')
    directory.pop
    directory = '/'+directory.join('/')
    unless File.directory?(directory)
      logger.info "Created directory #{directory}"
      FileUtils.mkdir_p(directory) 
    end
    logger.info "Created thumbnail #{self.physical_path}"
    image.write(self.physical_path)
  end
end
