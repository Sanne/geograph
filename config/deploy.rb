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


role :web, "149.165.148.103"
role :app, "149.165.148.107", "149.165.148.109"
role :db,  "149.165.148.110", :primary => true