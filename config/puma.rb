#!/usr/bin/env puma

# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 2

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"

if rails_env == "production"
  #!/usr/bin/env puma

  shared_dir = "#{app_dir}/shared"

  environment rails_env

  directory "#{app_dir}/current"
  rackup "#{app_dir}/current/config.ru"
  environment 'production'

  tag ''

  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  state_path "#{shared_dir}/tmp/pids/puma.state"
  stdout_redirect "#{app_dir}/current/log/puma.error.log", "#{app_dir}/current/log/puma.access.log", true

  bind "unix:#{shared_dir}/tmp/sockets/klangvorhang.krojo.001-puma.sock"

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

end