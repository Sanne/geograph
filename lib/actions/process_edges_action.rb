
# This file is the implementation of the  MoveAction.
# The implementation must comply with the action definition pattern
# that is briefly described in the Madmass::Action::Action class.

module Actions
  class ProcessEdgesAction < Madmass::Action::Action
    action_params :distance
    #action_states :none
    #next_state :none

    # [OPTIONAL]  Add your initialization code here.
    def initialize params
      super
      # PI = 3.1415926535
      @rad_per_deg = 0.017453293  #  PI/180
      # the great circle distance d will be in whatever units R is in
      @rmiles = 3956           # radius of the great circle in miles
      @rkm = 6371              # radius in kilometers...some algorithms use 6367
      @rfeet = @rmiles * 5282   # radius in feet
      @rmeters = @rkm * 1000    # radius in meters
    end


    # [MANDATORY] Override this method in your action to define
    # the action effects.
    def execute
      geo_objects = GeoObject.all
      geo_objects.each_with_index do |geo_object1, index|
        geo_objects[(index+1)..-1].each do |geo_object2|
            if haversine_distance(geo_object1, geo_object2) <= @parameters[:distance]
              edge = geo_object1.edges.build(:connection_id => geo_object2.id)
              edge.save
              inverse_edge = geo_object2.edges.build(:connection_id => geo_object1.id)
              inverse_edge.save
            end
        end
      end
    end

    # [MANDATORY] Override this method in your action to define
    # the perception content.
    def build_result
      Madmass.current_perception = []
    end

    # [OPTIONAL] - The default implementation returns always true
    # Override this method in your action to define when the action is
    # applicable (i.e. to verify the action preconditions).
    def applicable?
      unless job_enabled?
        why_not_applicable.add(:'job-disabled', 'The Edge Processor job is disabled.')
      end
    
      return why_not_applicable.empty?
    end

    # [OPTIONAL] Override this method to add parameters preprocessing code
    # The parameters can be found in the @parameters hash
    # def process_params
    #   puts "Implement me!"
    # end

    private

    def job_enabled?
      jobs = Job.where(:name => 'edges-processor')
      return true if jobs.empty?
      return jobs.first.enabled?
    end

    # Haversine formula to compute the great circle distance between two points given their latitude and longitudes
    def haversine_distance( geo_object1, geo_object2 )
      dlon = geo_object2.longitude - geo_object1.longitude
      dlat = geo_object2.latitude - geo_object1.latitude

      dlon_rad = dlon * @rad_per_deg
      dlat_rad = dlat * @rad_per_deg

      lat1_rad = geo_object1.latitude * @rad_per_deg
      lon1_rad = geo_object1.longitude * @rad_per_deg

      lat2_rad = geo_object2.latitude * @rad_per_deg
      lon2_rad = geo_object2.longitude * @rad_per_deg

      # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"

      a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
      c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

#      d_mi = @rmiles * c          # delta between the two points in miles
#      d_km = @rkm * c             # delta in kilometers
#      d_feet = @rfeet * c         # delta in feet
      d_meters = @rmeters * c     # delta in meters
      return d_meters
    end
  end

end
