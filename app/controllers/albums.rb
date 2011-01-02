require 'natural_sort_kernel'

Picty.controllers :albums do

  get :show, :map => '/albums/*album' do
    album = Album.from_param(params[:album])
    halt(404, "Album does not exists") unless album
    
    @pictures = album.pictures.sort do |x,y|
      a = [x.filename,y.filename]
      a_sorted = a.natural_sort
      if a_sorted == a
        -1
      else
        1
      end
    end
    @path = album.path
    # Convert the path to UTF-8 if Ruby 1.9
    @path.force_encoding('utf-8') if @path.respond_to?(:force_encoding)
    
    @page_title = album.path[1..-1]
    render 'albums/show'
  end

end
