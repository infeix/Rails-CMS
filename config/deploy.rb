# config valid only for current versiorequire 'capistrano/ext/multistage'n of Capistrano
lock '3.7.2'

set :application, 'Rails-CMS'
set :repo_url, 'git@github.com:infeix/Rails-CMS.git'
set :ruby_version, '2.3.1'

set :deploy_to, '/home/deploy/Rails-CMS'

append :linked_files, "config/database.yml", "config/secrets.yml", "config/initializers/devise.rb"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"
