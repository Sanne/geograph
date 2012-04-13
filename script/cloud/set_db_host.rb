# This script given a host name of the database master node and generates an appropriate database.yml file.
HOST_PLACEHOLDER = "{HOST}"
DBNAME_PLACEHOLDER = '{DBNAME}'

# app name (it must corresponds to the source code folder that contain the project)
#appname = "geograph"
appname = ARGV[0]
dbname = ARGV[1]

# load the db host from the cluster_nodes.yml generated during nimbus 1-ipandhost phase
conf_file = "cluster_nodes.yml"
hosts_file_path = File.join("/tmp", conf_file)
hosts = {}
File.open(hosts_file_path, 'r') do |file|
  hosts = YAML.load(file.read)
end
host = hosts[:db_nodes].first

puts "start setting db host with arguments app: #{appname} db ip: #{host} ..."

# this is the absolute path of geograph source code inside the cloud nodes
source_root = "/opt/apps/#{appname}/current"

# path to the database.yml configuration file
database_conf = File.join("#{source_root}", 'config', 'database.yml')

current_path = File.dirname(File.expand_path(__FILE__))
# path to the database.yml template file
database_conf_template = File.join("#{current_path}", 'templates', 'database.yml.template')


# open the template file, replace the HOST_PLACEHOLDER with the host argument and override the original conf file
File.open(database_conf_template, 'r') do |template|
  db_conf = template.read.gsub(HOST_PLACEHOLDER, host)
  db_conf.gsub!(DBNAME_PLACEHOLDER, dbname)
  #puts "changing database configuration with: \n #{db_conf}"
  File.open(database_conf, 'w') do |original|
    original.write db_conf
  end
end

puts "db host set!"