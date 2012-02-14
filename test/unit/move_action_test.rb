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

require File.join('test', 'test_helper')
require File.dirname(__FILE__)+'/../../lib/actions/move_action.rb'


class MoveActionTest < ActiveSupport::TestCase


  test "a Move" do
    agent = agents(:test_agent)
    assert_not_nil agent
    status = agent.execute(:cmd => 'actions::move', :latitude => 41.889800, :longitude => 12.473400)
    perception = Madmass.current_perception
    assert perception
    # more testing code here
    assert_equal 1, perception.size 
    percept = perception.first
    puts percept.inspect
    assert_equal 41.889800, percept.data[:latitude]
    assert_equal 12.473400, percept.data[:longitude]
    assert_equal agent.id, percept.data[:agent]
  end

end
