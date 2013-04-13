require "rvm/capistrano"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_install_type, :stable

# Install RVM
before 'deploy',         'rvm:install_rvm'
# Install Ruby
before 'deploy',         'rvm:install_ruby'
