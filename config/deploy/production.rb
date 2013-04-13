set :rails_env, "production"
set :user, "staging"
set :domain, "babysworld.tw"
set :branch, "master"
set :application, "babysworld-production"
set :environment, "production"

server "#{domain}", :web, :app, :db, :primary => true
set :deploy_to, "/home/#{user}/#{application}"
