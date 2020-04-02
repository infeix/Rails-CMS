

set :repo_url, 'git@github.com:infeix/Rails-CMS.git'
set :ruby_version, '2.5.7'

append :linked_files, "config/database.yml", "config/secrets.yml", "config/initializers/devise.rb", "public/favicon.ico"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "public/images"

set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
set :rollbar_env, Proc.new { :production }
set :rollbar_role, Proc.new { :app }
