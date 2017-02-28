# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'Rails-CMS'
set :repo_url, 'git@github.com:infeix/Rails-CMS.git'
set :ruby_version, '2.3.1'

set :bundle_bins, %w(rake ruby rails)
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :pty, false

set :linked_dirs, fetch(:linked_dirs, []).push('storage')
set :user, "deploy"

