###############################################################################
###############################################################################
#
# This file is part of GeoGraph.
#
# Copyright (c) 2012 Algorithmica Srl
#
# GeoGraph is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GeoGraph is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with GeoGraph.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact us via email at info@algorithmica.it or at
#
# Algorithmica Srl
# Vicolo di Sant'Agata 16
# 00153 Rome, Italy
#
###############################################################################
###############################################################################

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
