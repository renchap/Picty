class Picture
  attr_reader :filename, :album
  
  EXIF_METADATA = {
    :camera_model => 'model',
    :exposure => 'ExposureTime',
    :aperture => 'FNumber',
    :iso => 'isoSpeedRatings',
    :focal_lenght => 'FocalLength',
    :date => 'DateTimeOriginal',
  }

  IPTC_METADATA = {
    :title => '2:05',
    :caption => '2:120',
  }

  # Create methods to get metadata
  EXIF_METADATA.merge(IPTC_METADATA).each do |key, value|
    define_method(key) do
      self.get_metadata(key)
    end
  end


  class NotFound < Exception
  end

  def initialize(path)
    
    ar = path.split('/')
    
    # Filename is the last part
    @filename = ar.pop
    @metadata = nil

    begin
      @album = Album.get_album("/#{ar.join('/')}")
    rescue Album::NotFound => e
      # Picture not found if album is not found
      raise Picture::NotFound, "Album not found for picture #{path}"
    end
    
    # Picture not found if the picture does not exists on disk
    raise Picture::NotFound, "Picture #{path} not found" unless File.file?(self.physical_path)

    # Dynamically create methods for all metadata
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
    self.album.path+'/'+self.filename
  end
  
  def physical_path
    Padrino.root("public/pictures#{self.path}")
  end
  
  def url
    "/pictures#{self.path}".gsub(' ','%20')
  end

  def get_metadata(name)
    unless @metadata
      @metadata = Hash.new
      # Get metadata from image using minimagick
      img = MiniMagick::Image.open(self.physical_path)

      # We request all needed metadatas at one to call ImageMagick only one and speed up the process
      to_query = Array.new
      keys = Array.new

      EXIF_METADATA.each do |key, value|
        keys << key
        to_query << "%[EXIF:#{value}]"
      end

      IPTC_METADATA.each do |key, value|
        keys << key
        to_query << "%[IPTC:#{value}]"
      end
      
      # Hope nobody uses this separator in metadata
      data = img[to_query.join('\r||\r')]
      data.split("\r||\r").each_with_index do |value,index|
        @metadata[keys[index.to_i]] = value if value
      end

      # Better format for some metadata

      if @metadata[:aperture]
        s = @metadata[:aperture].split('/')
        @metadata[:aperture] = (s[0].to_f/s[1].to_f).to_s
      end

      [:exposure, :focal_lenght].each do |key|
        if @metadata[key]
          s = @metadata[key].split('/')
          if s[1] == '1'
            @metadata[key] = s[0]
          end
        end
      end

      @metadata[:date] = DateTime.strptime(@metadata[:date], '%Y:%m:%d %T') if @metadata[:date]

      logger.debug "Metadatas for #{self.path} : "+@metadata.to_s
      img.destroy!
    end
    @metadata[name]
  end

  def thumbnail
    @thumbnail = Thumbnail.new(self) unless @thumbnail
    @thumbnail
  end
end
