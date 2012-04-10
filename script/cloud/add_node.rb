require 'yaml'

key = ARGV[0].to_sym
host = ARGV[1]

puts "adding node for #{key}: #{host} ..."

conf_file = "cluster_nodes.yml"
conf_path = File.join("/tmp", conf_file)

hosts = {}

if File.exists?(conf_path)
  File.open(conf_path, 'r') do |file|
    hosts = YAML.load(file.read)
  end
end

hosts[key] ||= []
hosts[key] << host
hosts_dump = YAML.dump hosts
File.open(conf_path, 'w') do |file|
  file.write hosts_dump
end

puts "node added."