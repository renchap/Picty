require 'natural_sort_kernel'

Picty.controllers :albums do

  get :show, :map => '/albums/*album' do
    directory = Directory.from_param(params[:album])
    halt(404, "Picture does not exists") unless directory
    
    @pictures = directory.pictures.sort do |x,y|
      a = [x.filename,y.filename]
      a_sorted = a.natural_sort
      if a_sorted == a
        -1
      else
        1
      end
    end
    @path = directory.path
    # Convert the path to UTF-8 if Ruby 1.9
    @path.force_encoding('utf-8') if @path.respond_to?(:force_encoding)
    render 'albums/show'
  end

end
