require 'natural_sort_kernel'

Picty.controllers :albums do

  get :show, :map => '/albums/*path' do
    d = Directory.get_directory('/'+params[:path].join('/'))
    @pictures = d.pictures.sort do |x,y|
      a = [x.filename,y.filename]
      a_sorted = a.natural_sort
      if a_sorted == a
        -1
      else
        1
      end
    end
    @path = d.path
    # Convert the path to UTF-8 if Ruby 1.9
    @path.force_encoding('utf-8') if @path.respond_to?(:force_encoding)
    render 'albums/show'
  end

end
