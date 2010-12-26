# Helper methods defined here can be accessed in any controller or view in the application

Picty.helpers do
  def display_menu
    dir = Array.new
    Directory.get_directory('/').children.each do |child|
      dir << { :name => child.name, :path => child.path, :nb_images => child.number_of_images }
    end
    partial 'menu/submenu', :object => dir
  end
end