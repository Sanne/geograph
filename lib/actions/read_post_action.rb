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

require 'haversine_distance'
# This file is the implementation of the  MoveAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class ReadPostAction < Madmass::Action::Action
    action_params :latitude, :longitude
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
      geo_object = CloudTm::GeoObject.new
      geo_object.latitude = java.math.BigDecimal.new(@parameters[:latitude])
      geo_object.longitude = java.math.BigDecimal.new(@parameters[:longitude])
      
      @posts_read = []
      CloudTm::GeoObject.all.each do |post_obj|
        next if post_obj.type != "BloggerAgent"
        if HaversineDistance.calculate(geo_object, post_obj) <= @enabled_job.distance
          @posts_read << post_obj
        end
      end
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      p.data =  {
        :posts_read => []
      }
      @posts_read.each do |pread|
        p.data[:posts_read] << {
          :id => pread.oid,
          :latitude => pread.latitude.to_s,
          :longitude => pread.longitude.to_s
        }
      end

      Madmass.current_perception = []
      Madmass.current_perception << p
    end


    # [OPTIONAL] - The default implementation returns always true
    # Override this method in your action to define when the action is
    # applicable (i.e. to verify the action preconditions).
    def applicable?
      @enabled_job = CloudTm::Job.all.detect do |job|
        job.enabled
      end
      unless @enabled_job
        why_not_applicable.add(:'no-processor-configured', 'Posts cannot be read without a Edge Processor configured')
      end
      return why_not_applicable.empty?
    end

  end

end
