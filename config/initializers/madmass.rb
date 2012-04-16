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

  Madmass.setup do |config|
    # Configure Madmass in order to use the Active Record transaction adapter,
    # default is :"Madmass::Transaction::NoneAdapter".
    # You can also create your own adapter and pass it to the configuration
    # {"config.tx_adapter = :'Madmass::Transaction::ActiveRecordAdapter'" if @ar}

	# Configure Madmass to use
    #config.tx_adapter = :'Madmass::Transaction::TorqueBoxAdapter'
    config.tx_adapter = :'CloudTm::Transaction::CloudTmAdapter'
    #config.perception_sender = :"Madmass::Comm::SockySender"
    config.perception_sender = :"Madmass::Comm::JmsSender"

    Madmass::Utils::InstallConfig.init
 end
