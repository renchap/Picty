Picty.controllers :pictures do

  get :show, :map => '/pictures/*picture' do
    @picture = Picture.from_param(params[:picture])
    halt(404, "Picture not found") unless @picture
   
    @page_title = @picture.title if @picture.title
    render 'pictures/show'
  end

end
