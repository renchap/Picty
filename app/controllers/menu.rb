Picty.controllers :menu do
  
  get :root_menu, :map => '/menu/root', :provides => :json do
    Directory.get_directory('/').children.map do |child|
      child.path
    end.to_json
  end

  get :dir_children, :map => '/menu/*path/children.json' do
    directory = Directory.get_directory('/'+params[:path].join('/'))
    
    content_type :json
    
    directory.children.map do |child|
      child.path
    end.to_json
  end

end