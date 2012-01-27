
# This file is the implementation of the  MoveAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class ProcessEdgesAction < Madmass::Action::Action
    action_params :distance
    #action_states :none
    #next_state :none

    # [OPTIONAL]  Add your initialization code here.
    #    def initialize params
    #      super
    #    end


    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      @edges = []
      geo_objects = CloudTm::GeoObject.all
      geo_objects.each_with_index do |geo_object1, index|
        # remove previous edges
        geo_object1.getIncoming.each do |inc|
          geo_object1.removeIncoming(inc)
        end
        geo_object1.getOutcoming.each do |out|
          geo_object1.removeOutcoming(out)
        end
        # connect edges
        geo_objects.to_a[(index+1)..-1].each do |geo_object2|
          if HaversineDistance.calculate(geo_object1, geo_object2) <= @parameters[:distance]
            geo_object1.addIncoming(geo_object2)
            geo_object2.addIncoming(geo_object1)
            @edges << [geo_object1, geo_object2]
          end
        end
      end
    end

    def execute_ar
      geo_objects = GeoObject.all
      geo_objects.each_with_index do |geo_object1, index|
        # remove previous edges
        geo_object1.edges.clear
        # connect edges
        geo_objects[(index+1)..-1].each do |geo_object2|
          if HaversineDistance.calculate(geo_object1, geo_object2) <= @parameters[:distance]
            edge = geo_object1.edges.build(:connection_id => geo_object2.id)
            edge.save
            inverse_edge = geo_object2.edges.build(:connection_id => geo_object1.id)
            inverse_edge.save
          end
        end
      end
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      p.add_headers({:topics => ['all']}) #who must receive the percept
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

    def build_result_ar
      p = Madmass::Perception::Percept.new(self)
      p.add_headers({:topics => ['all']}) #who must receive the percept
      p.data =  {:edges => []}
      Edge.all.each do |edge|
        edge_data = {:from => {
            :id => edge.geo_object.id,
            :latitude => edge.geo_object.latitude,
            :longitude => edge.geo_object.longitude
          }, :to => {
            :id => edge.connection.id,
            :latitude => edge.connection.latitude,
            :longitude => edge.connection.longitude
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
      jobs = CloudTm::Job.where(:name => 'edges-processor')
      # FIXME: must return false when jobs integrated
      return true if jobs.empty?
      return jobs.first.enabled?
    end

    def job_enabled_ar?
      jobs = Job.where(:name => 'edges-processor')
      # FIXME: must return false when jobs integrated
      return true if jobs.empty?
      return jobs.first.enabled?
    end

  end

end
