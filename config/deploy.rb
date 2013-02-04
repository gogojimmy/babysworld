require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano_colors'
require "rvm/capistrano"
require "delayed/recipes"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_install_type, :stable

set :application, "babysworld"
set :repository,  "git@github.com:gogojimmy/babysworld.git"

set :scm, :git
set :scm_verbose, true
set :use_sudo, false

set :stages, %(staging production)
set :default_stage, "staging"
#set :rails_env, "production" #added for delayed job

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

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

  namespace :assets do
    #task :precompile, :role => :app do
      #run "cd #{release_path}/ && RAILS_ENV=staging bundle exec rake assets:precompile --trace"
    #end
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run_locally "bundle exec rake assets:precompile"
        find_servers_for_task(current_task).each do |server|
          run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
        end
        run_locally "rm -rf public/assets/*"
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end

end

desc "Remote console"
task :console, :roles => :app do
  env = stage || "production"
  server = find_servers(:roles => [:app]).first
  run_with_tty server, %W( bundle exec rails console #{env} )
end

desc "Remote dbconsole"
task :dbconsole, :roles => :app do
  env = stage || "production"
  server = find_servers(:roles => [:app]).first
  run_with_tty server, %W( rails dbconsole #{env} )
end

def run_with_tty(server, cmd)
  # looks like total pizdets
  command = []
  command += %W( ssh -t #{gateway} -l #{self[:gateway_user] || self[:user]} ) if     self[:gateway]
  command += %W( ssh -t )
  command += %W( -p #{server.port}) if server.port
  command += %W( -l #{user} #{server.host} )
  command += %W( cd #{current_path} )
  # have to escape this once if running via double ssh
  command += [self[:gateway] ? '\&\&' : '&&']
  command += Array(cmd)
  system *command
end

task :tail_log, :roles => :app do
  run "tail -f #{shared_path}/log/#{rails_env}.log"
end

namespace :mysql do
  task :sync do ; end

  task :backup, :roles => :db, :only => { :primary => true } do
    run "mkdir -p #{shared_path}/backup"
    filename = "#{shared_path}/backup/#{application}.sql"
    text = capture "cat #{deploy_to}/current/config/database.yml"
    yaml = YAML::load(text)

    on_rollback { run "rm #{filename}" }
    run "mysqldump -u #{yaml[rails_env]['username']} -p #{yaml[rails_env]['database']} > #{filename}" do |ch, stream, out|
      ch.send_data "#{yaml[rails_env]['password']}\n" if out =~ /^Enter password:/
    end
  end

  task :import do
    config = YAML.load_file("config/database.yml")["development"]
    username, password, database = config.values_at *%w( username password database )

    remote_file = "#{shared_path}/backup/#{application}.sql"
    local_filename = "mysql_backup/#{application}.sql"

    run_locally "mkdir -p mysql_backup"
    get "#{remote_file}", local_filename

    mysql_cmd = "mysql -u#{username}"
    mysql_cmd += " -p#{password}" if password
    `#{mysql_cmd} -e "drop database #{database}; create database #{database}"`
    `#{mysql_cmd} #{database} < #{local_filename}`
  end
end

task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
end

before "deploy:assets:precompile", "deploy:custom_setup"
# Install RVM
before 'deploy',         'rvm:install_rvm'
# Install Ruby
before 'deploy',         'rvm:install_ruby'
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "mysql:sync", "mysql:backup", "mysql:import"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
