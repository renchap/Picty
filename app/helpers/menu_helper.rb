# Helper methods defined here can be accessed in any controller or view in the application

Picty.helpers do
  def display_menu
    dir = Array.new
    Directory.get_directory('/').children.each do |child|
      dir << { :name => child.name, :path => child.path, :nb_images => child.number_of_images }
    end
    if dir.length == 0
      render :haml, '%p No images', :layout => false
    else
      partial 'menu/submenu', :object => dir
    end
  end
end
