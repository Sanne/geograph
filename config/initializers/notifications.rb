ActiveSupport::Notifications.subscribe "madmass.command_received"  do |name, start, finish, id, payload|
#  MessageCounter.instance.cmd_received
end

ActiveSupport::Notifications.subscribe "madmass.perception_sent"  do |name, start, finish, id, payload|
#  MessageCounter.instance.percept_sent
end

