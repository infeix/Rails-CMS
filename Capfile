
require 'capistrano/setup'

require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/bundler'
require 'capistrano/puma'
install_plugin Capistrano::Puma  # Default puma tasks
install_plugin Capistrano::Puma::Nginx
require 'capistrano/rails'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

require 'capistrano/rails/console'
require 'capistrano/console'
