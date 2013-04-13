require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano_colors'
require "delayed/recipes"

load "config/recipes/base"
load "config/recipes/rvm"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/nodejs"
load "config/recipes/mysql"
load "config/recipes/rvm"
load "config/recipes/check"
load "config/recipes/assets"
load "config/recipes/remote_commands"

set :application, "babysworld"
set :repository,  "git@github.com:gogojimmy/babysworld.git"

set :scm, :git
set :scm_verbose, true
set :use_sudo, false

set :stages, %(staging production)
set :default_stage, "staging"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  task :custom_setup, :roles => [:app] do
    run "cp #{shared_path}/config/*.yml #{release_path}/config/"
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
  task :reset_db do
    run "cd #{current_path}; rake db:reset RAILS_ENV=#{rails_env}"
  end
end

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
