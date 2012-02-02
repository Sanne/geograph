# This service calculates all edges between geo objects and send them to the all channel.
class EdgesProcessor
  def initialize(options = {})
    @options = options
    Madmass.current_agent = Madmass::Agent::ProxyAgent.new(:status => 'init')
  end

  # Starts the production
  def run
    Rails.logger.debug "Processing Edges"
    Madmass.current_agent.execute({ :cmd => 'actions::process_edges' })
  end

end
