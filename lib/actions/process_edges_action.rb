require 'haversine_distance'

# This file is the implementation of the  MoveAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class ProcessEdgesAction < Madmass::Action::Action
    #action_params :distance
    #action_states :none
    #next_state :none

    def initialize params
     super
     @channels << :all
    end


    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      @edges = []
      geo_objects = CloudTm::GeoObject.all
      geo_objects.each_with_index do |geo_object1, index|
        # remove previous edges
        geo_object1.remove_edges
        # connect edges
        geo_objects.to_a[(index+1)..-1].each do |geo_object2|
          if HaversineDistance.calculate(geo_object1, geo_object2) <= @job.distance
            geo_object1.addIncoming(geo_object2)
            geo_object2.addIncoming(geo_object1)
            @edges << [geo_object1, geo_object2]
          end
        end
      end
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
#      p.add_headers({:topics => ['all']}) #who must receive the percept
      p.data =  {:edges => []}
      @edges.each do |edge|
        edge_data = {:from => {
            :id => edge.first.oid,
            :latitude => edge.first.latitude.to_s,
            :longitude => edge.first.longitude.to_s
          }, :to => {
            :id => edge.last.oid,
            :latitude => edge.last.latitude.to_s,
            :longitude => edge.last.longitude.to_s
          }}
        p.data[:edges] << edge_data
      end
      Madmass.current_perception = []
      Madmass.current_perception << p
    end

    # [OPTIONAL] - The default implementation returns always true
    # Override this method in your action to define when the action is
    # applicable (i.e. to verify the action preconditions).
    def applicable?
      unless job_enabled?
        why_not_applicable.add(:'job-disabled', 'The Edge Processor job is disabled.')
      end
    
      return why_not_applicable.empty?
    end

    # [OPTIONAL] Override this method to add parameters preprocessing code
    # The parameters can be found in the @parameters hash
    # def process_params
    #   puts "Implement me!"
    # end

    private

    def job_enabled?
      jobs = CloudTm::Job.where(:name => 'job')
      return false if jobs.empty?
     @job = jobs.first
      return @job.enabled?
    end

  end

end
