require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano_colors'

load "config/recipes/base"
load "config/recipes/rvm"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/nodejs"
load "config/recipes/mysql"
load "config/recipes/check"
load "config/recipes/assets"
load "config/recipes/remote_commands"

set :repository,  "git@github.com:gogojimmy/babysworld.git"

set :scm, :git
set :scm_verbose, true
set :use_sudo, false
set :shared_children, shared_children + %w{public/uploads}

set :stages, %(staging production)
set :default_stage, "staging"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  task :custom_setup, :roles => [:app] do
    #run "cp #{shared_path}/config/*.yml #{release_path}/config/"
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
  task :reset_db do
    run "cd #{current_path}; rake db:reset RAILS_ENV=#{rails_env}"
  end

  task :symlink_uploads do
     run "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"
   end
end

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after 'deploy:update_code', 'deploy:symlink_uploads'
