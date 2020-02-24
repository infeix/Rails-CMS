#!/usr/bin/env puma

# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 1

app_dir = "/home/deploy/klangvorhang.krojo.001"
shared_dir = "#{app_dir}/shared"

# Default to staging
rails_env = ENV['RAILS_ENV'] || "staging"
environment rails_env

directory "#{app_dir}/current"
rackup "#{app_dir}/current/config.ru"
environment 'staging'

tag ''

pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"
stdout_redirect "#{app_dir}/current/log/puma.error.log", "#{app_dir}/current/log/puma.access.log", true


threads 1,1



bind "unix://#{shared_dir}/tmp/sockets/Rails-CMS-puma.sock"

workers 1




restart_command 'bundle exec puma'


preload_app!


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end




# Set up socket location
#bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
#stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
#pidfile "#{shared_dir}/pids/puma.pid"
#state_path "#{shared_dir}/pids/puma.state"
#activate_control_app

#on_worker_boot do
#  require "active_record"
#  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
#  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
#end
