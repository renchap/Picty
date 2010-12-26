Picty.controllers :albums do

  get :show, :map => '/albums/*path' do
    d = Directory.get_directory('/'+params[:path].join('/'))
    @pictures = d.pictures
    @path = d.path.force_encoding('utf-8')
    render 'albums/show'
  end

end