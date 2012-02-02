
# This file is the implementation of the  CreateAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class DestroyAction < Madmass::Action::Action
    action_params :geo_object
    
    def initialize params
     super
     @channels << :all
    end
    
    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      geo_object = CloudTm::GeoObject.find(@parameters[:geo_object])
      geo_object.destroy if geo_object
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
      #p.add_headers({:topics => ['all']}) #who must receive the percept
      p.data =  {:geo_object => {
          :id => @parameters[:geo_object]
          }
      }
      Madmass.current_perception << p
    end

  end

end