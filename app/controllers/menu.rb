Picty.controllers :menu do
  
  get :root_menu, :map => '/menu/root', :provides => :json do
    Album.get_album('/').children.map do |child|
      child.path
    end.to_json
  end

  get :dir_children, :map => '/menu/*path/children.json' do
    album = Album.get_album('/'+params[:path].join('/'))
    
    content_type :json
    
    album.children.map do |child|
      child.path
    end.to_json
  end

end
