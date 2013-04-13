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

task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
end
