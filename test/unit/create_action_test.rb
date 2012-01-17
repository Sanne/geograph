require File.join('test', 'test_helper')
require File.dirname(__FILE__)+'/../../lib/actions/create_action.rb'


class CreateActionTest < ActiveSupport::TestCase


  test "a Create" do

    agent = Madmass::Agent::ProxyAgent.new

    assert_not_nil agent

    status = agent.execute(:cmd => 'actions::create')

    perception = Madmass.current_perception

    assert perception

    #more testing code here

  end

end