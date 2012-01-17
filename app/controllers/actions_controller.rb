
class ActionsController < ApplicationController
  protect_from_forgery

  respond_to :json, :html

  include ApplicationHelper
  include ActionView::Helpers::JavaScriptHelper

  before_filter :authenticate_agent

  def execute
    topic = TorqueBox::Messaging::Topic.new('/topics/commands')
    topic.connect_options = {
      :naming_host => Madmass.install_options(:naming_host),
      :naming_port => Madmass.install_options(:naming_port)
    }
    topic.publish("a message", :properties => {
                                        :recipient => 'madmass',
                                        :sender => 'agent_x'
                                       })
                                     status = 200
  respond_to do |format|
      format.html {render :execute, :status => status}
      format.json {render :json => "ciao".to_json, :status => status}
    end
  end

  def execute_old
      return unless params[:agent]
      status = Madmass.current_agent.execute(params[:agent])
      @perception = Madmass.current_perception;

    respond_to do |format|
      format.html {render :execute, :status => status}
      format.json {render :json => @perception.to_json, :status => status}
    end
 
 rescue Madmass::Errors::StateMismatchError
    # redirect_to :action => current_user.state
 
 end



end

