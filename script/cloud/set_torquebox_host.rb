require 'yaml'

# This script given a host name of the torquebox node node and generates an appropriate standalone-ha.xml file.

host = %x(hostname).gsub("\n", '')
appname = ARGV[0]

puts "configuring #{appname}/torquebox with host #{host} ..."

conf_file = "cluster_nodes.yml"
hosts_file_path = File.join("/tmp", conf_file)
hosts = {}
File.open(hosts_file_path, 'r') do |file|
  hosts = YAML.load(file.read)
end


# Constants:
JGROUPS_TCP_PORT = 7600

# Placeholders:
MODCLUSTER_PLACEHOLDER = "{MODCLUSTER_HOST}"
INFINISPAN_PLACEHOLDER = "{INFINISPAN_HOSTS_AND_PORTS}"
CONNECTORS_PLACEHOLDER = "{HORNETQ_CONNECTORS}"
BINDINGS_PLACEHOLDERS = "{HORNETQ_BINDINGS}"
HOST_PLACEHOLDER = "{THIS_HOST}"

# this is the absolute path of geograph source code inside the cloud nodes
source_root = "/opt/torquebox/current/jboss/standalone/configuration"
current_path = File.dirname(File.expand_path(__FILE__))

# path to the httpd.conf configuration file to replace
torquebox_conf = File.join("#{source_root}", 'standalone-ha.xml')

# path to the httpd.conf template file
torquebox_conf_template = File.join("#{current_path}", 'templates', 'standalone-ha.xml.tb-2.0.0.template')

app_nodes_key = nil
case appname
when  "geograph"
  app_nodes_key = :geograph_nodes
  modcluster_nodes_key = :geograph_modcluster_nodes
when "geograph-agent-farm"
  app_nodes_key = :agent_farm_nodes
  modcluster_nodes_key = :agent_farm_modcluster_nodes
end

# prepare infinispan configuration
infinispan_conf = hosts[app_nodes_key].map{|_host| "#{_host}[#{JGROUPS_TCP_PORT}]"}.join(',')
# prepare hornetq configuration
hornetq_connectors_conf = []
hornetq_bindings_conf = []
hosts[app_nodes_key].each_with_index do |_host, index|
  hornetq_connectors_conf << <<EOC
  <netty-connector name="server#{index}-connector" socket-binding="messaging-server#{index}"/>
EOC
  hornetq_bindings_conf << <<EOB
  <outbound-socket-binding name="messaging-server#{index}">
    <remote-destination host="#{_host}" port="5445"/>
  </outbound-socket-binding>
EOB

end


# open the template file, replace the HOST_PLACEHOLDER with the host argument and override the original conf file
File.open(torquebox_conf_template, 'r') do |template|
  tb_conf = template.read.gsub(HOST_PLACEHOLDER, host)
  tb_conf.gsub!(MODCLUSTER_PLACEHOLDER, hosts[modcluster_nodes_key].join(','))
  tb_conf.gsub!(INFINISPAN_PLACEHOLDER, infinispan_conf)
  tb_conf.gsub!(CONNECTORS_PLACEHOLDER, hornetq_connectors_conf.join("\n"))
  tb_conf.gsub!(BINDINGS_PLACEHOLDERS, hornetq_bindings_conf.join("\n"))

  File.open(torquebox_conf, 'w') do |original|
    original.write tb_conf
  end
end

puts "#{appname}/torquebox configured!"