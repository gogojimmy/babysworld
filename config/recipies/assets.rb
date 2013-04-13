namespace :assets do
  task :precompile, :role => :app do
    run "cd #{release_path}/ && RAILS_ENV=staging bundle exec rake assets:precompile --trace"
  end
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

before "deploy:assets:precompile", "deploy:custom_setup"
