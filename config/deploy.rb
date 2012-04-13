#Capistrano support
require 'torquebox-capistrano-support'
require 'bundler/capistrano'

# source code
set :application,       "geograph"
set :repository,        "https://github.com/algorithmica/geograph.git"
set :branch,            "master"
set :user,              "torquebox"
set :scm,               :git
set :scm_verbose,       true
set :use_sudo,          false
#set :test_server,       "vm-178.uc.futuregrid.org"
# Production server

set :deploy_to,         "/opt/apps/#{application}"
set :torquebox_home,    "/opt/torquebox/current"
set :jboss_init_script, "/etc/init.d/jboss-as-standalone"
#set :app_environment,   "RAILS_ENV: production" DOES NOT WORK!!!
set :app_context,       "/"


#Added by vittorio
#default_run_options[:pty] = true
#ssh_options[:verbose] = :debug
ssh_options[:auth_methods] = "publickey"
ssh_options[:keys] = %w(~/.ssh/id_rsa)
set :deploy_via, :remote_cache

ssh_options[:forward_agent] = false

#Precompile asset pipeline
load 'deploy/assets'


role :web, "vm-104.uc.futuregrid.org"
role :app, "vm-104.uc.futuregrid.org"
role :db,  "vm-104.uc.futuregrid.org", :primary => true