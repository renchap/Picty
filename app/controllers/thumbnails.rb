Picty.controllers :thumbnails do

  error Picture::NotFound do
    render :haml, "%p Picture not found"
  end


  get :show, :map => '/thumbs/*path' do
    thumbnail = Thumbnail.from_param(params[:path])
    halt(404, "Picture does not exists") unless thumbnail
    
    # If we are here, there is no cached thumb
    thumbnail.create!
    send_file(thumbnail.physical_path, :type => 'image/jpeg', :disposition => :inline)
  end

end
