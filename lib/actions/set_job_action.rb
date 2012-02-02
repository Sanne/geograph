
# This file is the implementation of the  CreateAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class SetJobAction < Madmass::Action::Action
    action_params :name, :enabled, :distance
    #action_states :none
    #next_state :none

    def initialize params
      super
      @clients << Madmass.current_agent.id
    end


    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      job = CloudTm::Job.where(:name => @parameters[:name]).first
      unless job
        job = CloudTm::Job.create
      end
      job.name = @parameters[:name]
      job.enabled = true
      job.distance = @parameters[:distance].to_i
      # disable all others jobs
      CloudTm::Job.all.each do |job|
        next if job.name == @parameters[:name]
        job.enabled = false
      end
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      p = Madmass::Perception::Percept.new(self)
#      p.add_headers({:clients => [Madmass.current_agent.id]}) #who must receive the percept
      p.data =  {:executed => true}
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