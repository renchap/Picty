# Helper methods defined here can be accessed in any controller or view in the application

Picty.helpers do
  def display_menu path = '/'
    children = Array.new
    Album.get_album(path).children.each do |child|
      children << child
    end
    if children.length == 0 and path == '/'
      render :haml, '%p No Albums', :layout => false
    else
      partial 'menu/children', :object => children
    end
  end
end
