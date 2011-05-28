##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount("blog").to('/blog')
#   Padrino.mount("blog", :app_class => "BlogApp").to('/blog')
#   Padrino.mount("blog", :app_file =>  "path/to/blog/app.rb").to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount("Admin").host("admin.example.org")
#   Padrino.mount("WebSite").host(/.*\.?example.org/)
#   Padrino.mount("Foo").to("/foo").host("bar.example.org")
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the parimary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount(:app_file => "path/to/file", :app_class => "Blog").to('/')
#

Padrino.configure_apps do
  enable :sessions
  # $ padrino rake gen
  # $ rake secret
  set :session_secret, "a9e2fe4220e797d9f826ec46997288d68ca7cef3b7535dbe064aa3f76db24190" 
end

# Mounts the core application for this project
Padrino.mount("Picty").to('/')