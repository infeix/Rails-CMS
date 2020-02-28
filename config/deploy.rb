

set :repo_url, 'git@github.com:infeix/Rails-CMS.git'
set :ruby_version, '2.5.7'

append :linked_files, "config/database.yml", "config/secrets.yml", "config/initializers/devise.rb"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "public/images"

