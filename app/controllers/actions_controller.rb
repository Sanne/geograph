###############################################################################
###############################################################################
#
# This file is part of GeoGraph.
#
# Copyright (c) 2012 Algorithmica Srl
#
# GeoGraph is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GeoGraph is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with GeoGraph.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact us via email at info@algorithmica.it or at
#
# Algorithmica Srl
# Vicolo di Sant'Agata 16
# 00153 Rome, Italy
#
###############################################################################
###############################################################################


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

