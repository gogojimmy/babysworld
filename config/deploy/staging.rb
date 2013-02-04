set :rails_env, "staging"
set :user, "staging"
set :domain, "staging.babysworld.tw"
set :branch, "develop"

server "#{domain}", :web, :app, :db, :primary => true
set :deploy_to, "/home/#{user}/#{application}"
