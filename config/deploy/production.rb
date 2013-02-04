set :rails_env, "production"
set :user, "deployer"
set :domain, "babysworld.tw"
set :branch, "master"

server "#{domain}", :web, :app, :db, :primary => true
set :deploy_to, "/home/#{user}/#{application}"
