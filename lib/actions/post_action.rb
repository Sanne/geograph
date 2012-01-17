
# This file is the implementation of the  MoveAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class PostAction < Madmass::Action::Action
    action_params :latitude, :longitude, :geo_agent, :data
    #action_states :none
    #next_state :none

    # [OPTIONAL]  Add your initialization code here.
    def initialize params
      super
      @geo_post = nil
    end


    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      # search if the agent related to all geo referenced posts (geo objects) exists
      @agent = Agent.where(:id => @parameters[:geo_agent]).first
      unless @agent
        # create the agent if it does not exists
        @agent = Agent.create
      end
      @geo_post = GeoObject.new(
        :latitude => @parameters[:latitude],
        :longitude => @parameters[:longitude],
        :data => @parameters[:data]
      )
      @agent.geo_objects << @geo_post
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      p.add_headers({:topics => ['all']}) #who must receive the percept
      p.data =  {
        :geo_agent => @agent.id,
        :geo_object => {
          :id => @geo_post.id,
          :latitude => @geo_post.latitude,
          :longitude => @geo_post.longitude,
          :data => @geo_post.data
          }
      }
      Madmass.current_perception = []
      Madmass.current_perception << p
    end

    # [OPTIONAL] - The default implementation returns always true
    # Override this method in your action to define when the action is
    # applicable (i.e. to verify the action preconditions).
    # def applicable?
    #
    #   if CONDITION
    #     why_not_applicable.add(:'DESCR_SYMB', 'EXPLANATION')
    #   end
    #
    #   return why_not_applicable.empty?
    # end

    # [OPTIONAL] Override this method to add parameters preprocessing code
    # The parameters can be found in the @parameters hash
    # def process_params
    #   puts "Implement me!"
    # end

  end

end
