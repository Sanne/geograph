
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