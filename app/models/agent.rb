class Agent < ActiveRecord::Base
 include Madmass::Agent::Executor
 has_many :geo_objects, :as => :geo_referenced, :dependent => :destroy
end
