require 'torquebox-cache'
class InternalCache
  include Singleton
  CMD_RCV_KEY = 'cmd-rcv' unless defined?(CMD_RCV_KEY)
  PERC_SENT_KEY = 'perc-sent' unless defined?(PERC_SENT_KEY)

  def initialize
    @cache = TorqueBox::Infinispan::Cache.new( :name => 'geograph' )
#    clear
  end

  def clear
    @cache.put(CMD_RCV_KEY, 0)
    @cache.put(PERC_SENT_KEY, 0)
  end

  def cmd_received
    @cache.increment(CMD_RCV_KEY)
    puts "Geograph Commands received: #{@cache.get(CMD_RCV_KEY)}"
  end

  def percept_sent
    @cache.increment(PERC_SENT_KEY)
    puts "Geograph Perceptions sent: #{@cache.get(PERC_SENT_KEY)}"
  end

  def print
    puts "Geograph Commands received: #{@cache.get(CMD_RCV_KEY)} - Perceptions sent: #{@cache.get(PERC_SENT_KEY)}"
  end
  
end
