Picty.controllers :pictures do

  get :show, :map => '/pictures/*picture' do
    @picture = Picture.from_param(params[:picture].join('/'))
    halt(404, "Picture not found") unless @picture
    
    render 'pictures/show'
  end

end
