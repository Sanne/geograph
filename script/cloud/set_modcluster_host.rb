# This script given a host name of the mod cluster node node and generates an appropriate httpd.conf file.
host = %x(hostname).gsub("\n", '')
puts "start setting mod cluster host with arguments #{host} ..."

HOST_PLACEHOLDER = "{HOST}"

# this is the absolute path of geograph source code inside the cloud nodes
source_root = "/opt/jboss/httpd/httpd/conf"
current_path = File.dirname(File.expand_path(__FILE__))

# path to the httpd.conf configuration file to replace
httpd_conf = File.join("#{source_root}", 'httpd.conf')

# path to the httpd.conf template file
httpd_conf_template = File.join("#{current_path}", 'templates', 'httpd.conf.template')


# open the template file, replace the HOST_PLACEHOLDER with the host argument and override the original conf file
File.open(httpd_conf_template, 'r') do |template|
  httpd_conf = template.read.gsub(HOST_PLACEHOLDER, host)
  File.open(httpd_conf, 'w') do |original|
    original.write httpd_conf
  end
end

puts "mod cluster host set!"