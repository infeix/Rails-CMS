

set :repo_url, 'git@github.com:infeix/Rails-CMS.git'
set :ruby_version, '2.3.1'

append :linked_files, "config/database.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "public/images"

