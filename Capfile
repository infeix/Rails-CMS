
require 'capistrano/setup'

require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
set :rvm_type, :user
set :rvm_ruby_version, '2.6.5'

require 'capistrano/bundler'
require 'capistrano/console'
require 'capistrano/rails/console'
require 'capistrano/rails'
require 'capistrano/passenger'
