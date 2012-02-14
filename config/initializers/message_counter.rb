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

class MessageCounter
  include Singleton
  CMD_RCV_KEY = 'cmd-rcv' unless defined?(CMD_RCV_KEY)
  PERC_SENT_KEY = 'perc-sent' unless defined?(PERC_SENT_KEY)

  def initialize
  end

  def clear
    cmd_rcv = Message.where(:name => CMD_RCV_KEY).first
    cmd_rcv.update_attribute(:count, 0) if cmd_rcv

    perc_sent = Message.where(:name => PERC_SENT_KEY).first
    perc_sent.update_attribute(:count, 0) if perc_sent
  end

  def cmd_received
    msg = increment(CMD_RCV_KEY)
    puts "Geograph Commands received: #{msg.count}"
  end

  def percept_sent
    msg = increment(PERC_SENT_KEY)
    puts "Geograph Perceptions sent: #{msg.count}"
  end

  def print
    puts ">>>>>>>>>>>> GEOGRAPH STATS <<<<<<<<<<<<<<<"
    cmd_rcv = Message.where(:name => CMD_RCV_KEY).first
    puts "Commands received: #{cmd_rcv ? cmd_rcv.count : 0}"
    
    perc_sent = Message.where(:name => PERC_SENT_KEY).first
    puts "Commands received: #{perc_sent ? perc_sent.count : 0}"
    puts "<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>"
  end

  private

  def increment(name)
    msg = Message.where(:name => name).first
    unless msg
      msg = Message.create(:name => name, :count => 0)
    end
    msg.count += 1
    msg.save
    msg
  end
  
end

#MessageCounter.instance.clear