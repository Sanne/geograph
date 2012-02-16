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


# This file is the implementation of the  MoveAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class MoveAction < Madmass::Action::Action
    action_params :latitude, :longitude, :geo_agent, :data
    #action_states :none
    #next_state :none

    # [OPTIONAL]  Add your initialization code here.
    def initialize params
      super
      @channels << :all
    end


    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      @agent = CloudTm::Agent.find(@parameters[:geo_agent])
      unless @agent
        @agent = CloudTm::Agent.create
      end

      has_geoobj = false
      if @agent.hasAnyGeoObjects
        @geo_object = @agent.getGeoObjects.first
        has_geoobj = true
      else
        @geo_object = CloudTm::GeoObject.create
      end

      @geo_object.update_attributes(
        :latitude => java.math.BigDecimal.new(@parameters[:latitude]),
        :longitude => java.math.BigDecimal.new(@parameters[:longitude]),
        :body => @parameters[:data][:body],
        :type => @parameters[:data][:type]
      )

      @agent.addGeoObjects(@geo_object) unless has_geoobj

      if edges_enabled?
        @geo_object.renew_edges(@job.distance)
      end
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      p.data =  {
        :geo_agent => @agent.oid,
        :geo_object => {
          :id => @geo_object.oid,
          :latitude => @geo_object.latitude.to_s,
          :longitude => @geo_object.longitude.to_s,
          :data => {:body => @geo_object.body, :type => @geo_object.type }
          }
      }

      if edges_enabled?
        p.data[:edges] = @geo_object.edges_for_percept
      end

      Madmass.current_perception = []
      Madmass.current_perception << p
    end


    # [OPTIONAL] - The default implementation returns always true
    # Override this method in your action to define when the action is
    # applicable (i.e. to verify the action preconditions).
#    def applicable?
#      unless @geo_object = CloudTm::GeoObject.find(@parameters[:geo_object])
#        why_not_applicable.add(:'not-found', "Geo object #{@parameters[:geo_object]} doesn't exists.")
#      end
#      return why_not_applicable.empty?
#    end

    # [OPTIONAL] Override this method to add parameters preprocessing code
    # The parameters can be found in the @parameters hash
    # def process_params
    #   puts "Implement me!"
    # end

    private

    def edges_enabled?
      jobs = CloudTm::Job.where(:name => 'action')
      return false if jobs.empty?
      @job = jobs.first
      return @job.enabled?
    end

  end

end
