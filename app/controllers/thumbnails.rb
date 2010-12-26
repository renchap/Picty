Picty.controllers :thumbnails do

  # If we are here, there is no cached thumb
  get :show, :map => '/thumbs/*path' do
    picture = Picture.new('/'+params[:path].join('/'))
    picture.thumbnail.create!
    send_file(picture.thumbnail.physical_path, :type => 'image/jpeg', :disposition => :inline)
  end

end