# config valid only for current versiorequire 'capistrano/ext/multistage'n of Capistrano
set :application, 'Rails-CMS'
set :repo_url, 'git@github.com:infeix/Rails-CMS.git'
set :ruby_version, '2.3.1'

set :deploy_to, '/home/deploy/Rails-CMS'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :pty, false

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

