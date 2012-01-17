require File.join('test', 'test_helper')
require File.dirname(__FILE__)+'/../../lib/actions/move_action.rb'


class MoveActionTest < ActiveSupport::TestCase


  test "a Move" do
    agent = agents(:test_agent)
    assert_not_nil agent
    status = agent.execute(:cmd => 'actions::move', :latitude => 41.889800, :longitude => 12.473400)
    perception = Madmass.current_perception
    assert perception
    # more testing code here
    assert_equal 1, perception.size 
    percept = perception.first
    puts percept.inspect
    assert_equal 41.889800, percept.data[:latitude]
    assert_equal 12.473400, percept.data[:longitude]
    assert_equal agent.id, percept.data[:agent]
  end

end
