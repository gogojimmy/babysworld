namespace :mysql do
  task :sync do ; end

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "create user #{mysql_user} with password '#{postgresql_password}';"}
    run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_database"

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

  desc "|DarkRecipes| Create MySQL database and user for this environment using prompted values"
  task :setup, :roles => :db, :only => { :primary => true } do
    prepare_for_db_command

    sql = <<-SQL
    CREATE DATABASE #{db_name};
    GRANT ALL PRIVILEGES ON #{db_name}.* TO #{db_user}@localhost IDENTIFIED BY '#{db_pass}';
    SQL

    run "mysql --user=#{db_admin_user} -p --execute=\"#{sql}\"" do |channel, stream, data|
      if data =~ /^Enter password:/
        pass = Capistrano::CLI.password_prompt "Enter database password for '#{db_admin_user}':"
        channel.send_data "#{pass}\n"
      end
    end
  end

  # Sets database variables from remote database.yaml
  def prepare_from_yaml
    set(:db_file) { "#{application}-dump.sql.bz2" }
    set(:db_remote_file) { "#{shared_path}/backup/#{db_file}" }
    set(:db_local_file)  { "tmp/#{db_file}" }
    set(:db_user) { db_config[rails_env]["username"] }
    set(:db_pass) { db_config[rails_env]["password"] }
    set(:db_host) { db_config[rails_env]["host"] }
    set(:db_name) { db_config[rails_env]["database"] }
  end

  def db_config
    @db_config ||= fetch_db_config
  end

  def fetch_db_config
    require 'yaml'
    file = capture "cat #{shared_path}/config/database.yml"
    db_config = YAML.load(file)
  end
end

def prepare_for_db_command
  set :db_name, "#{application}_#{environment}"
  set(:db_admin_user) { Capistrano::CLI.ui.ask "Username with priviledged database access (to create db):" }
  set(:db_user) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
  set(:db_pass) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
end

after "mysql:sync", "mysql:backup", "mysql:import"
