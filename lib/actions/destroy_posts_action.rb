
# This file is the implementation of the  CreateAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class DestroyPostsAction < Madmass::Action::Action
    action_params :geo_agent

    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      @geo_agent = Agent.find(@parameters[:geo_agent])
      #geo_agent.destroy if geo_agent
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      p.add_headers({:topics => ['all']}) #who must receive the percept
      p.data =  {:geo_object => {
          :ids => @geo_agent.geo_objects.map(&:id)
          }
      }
      Madmass.current_perception << p
    end

  end

end