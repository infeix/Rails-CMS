set :stage, :staging




server 'dj-duo-jobe.de',
       user: 'deploy',
       roles: [:app, :web, :cron, :db],
       primary: true,
       ssh_options: {
         keys: %w{~/.ssh/id_rsa},
         forward_agent: true,
         auth_methods: %w(publickey)
       }

set :user, 'deploy'
set :branch, :master
