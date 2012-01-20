# This service calculates all edges between geo objects and send them to the all channel.
class EdgesProcessor
  def initialize(options = {})
    @options = options
  end

  # Starts the production
  def run
    Rails.logger.debug "Processing Edges"
    action = Madmass::Action::ActionFactory.make({
        :cmd => 'actions::process_edges',
        :distance => 10000
      })
    action.execute
  end

end
