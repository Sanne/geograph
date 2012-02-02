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
