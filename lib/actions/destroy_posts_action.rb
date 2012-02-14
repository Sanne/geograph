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


# This file is the implementation of the  CreateAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class DestroyPostsAction < Madmass::Action::Action
    action_params :geo_agent

    def initialize params
     super
     @channels << :all
    end
    
    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      @ids = []
      @geo_agent.getGeoObjects.each do |geo_object|
        @ids << geo_object.oid
        geo_object.destroy
      end
      @geo_agent.destroy
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      #p.add_headers({:topics => ['all']}) #who must receive the percept
      p.data =  {:geo_object => {
          :ids => @ids
          }
      }
      Madmass.current_perception << p
    end

    # [OPTIONAL] - The default implementation returns always true
    # Override this method in your action to define when the action is
    # applicable (i.e. to verify the action preconditions).
    def applicable?
      unless @geo_agent = CloudTm::Agent.find(@parameters[:geo_agent])
        why_not_applicable.add(:'not-found', "Agent #{@parameters[:geo_agent]} doesn't exists.")
      end
      return why_not_applicable.empty?
    end

  end

end