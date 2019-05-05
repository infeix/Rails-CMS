set :stage, :staging

server 'staging-server.com',
       user: 'deploy',
       roles: [:app, :web, :cron, :db],
       primary: true,
       ssh_options: {
         keys: %w{~/.ssh/id_rsa},
         forward_agent: true,
         auth_methods: %w(publickey)
       }

set :user, 'deploy'
set :branch, :staging
