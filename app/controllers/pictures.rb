Picty.controllers :pictures do

  get :show, :map => '/pictures/*path' do
    @picture = Picture.from_param(params[:path].join('/'))
    render 'pictures/show'
  end


end
