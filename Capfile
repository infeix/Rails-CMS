
require 'capistrano/setup'

require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git


require 'capistrano/bundler'
require 'capistrano/console'
require 'capistrano/rails/console'
require 'capistrano/rails'
require 'capistrano/passenger'

require 'capistrano/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.5.7'