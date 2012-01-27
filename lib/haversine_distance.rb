require File.join(Rails.root, 'lib', 'big_decimal')

# Haversine formula to compute the great circle distance between two points given their latitude and longitudes
# PI = 3.1415926535
RAD_PER_DEG = 0.017453293  #  PI/180
# the great circle distance d will be in whatever units R is in
RMILES = 3956           # radius of the great circle in miles
RKM = 6371              # radius in kilometers...some algorithms use 6367
RFEET = RMILES * 5282   # radius in feet
RMETERS = RKM * 1000    # radius in meters

class HaversineDistance
  class << self

    def calculate( geo_object1, geo_object2 )
      lat1 = geo_object1.latitude.to_f
      lon1 = geo_object1.longitude.to_f
      lat2 = geo_object2.latitude.to_f
      lon2 = geo_object2.longitude.to_f

      dlon = lon2 - lon1
      dlat = lat2 - lat1

      dlon_rad = dlon * RAD_PER_DEG
      dlat_rad = dlat * RAD_PER_DEG

      lat1_rad = lat1 * RAD_PER_DEG
      lon1_rad = lon1 * RAD_PER_DEG
      lat2_rad = lat2 * RAD_PER_DEG
      lon2_rad = lon2 * RAD_PER_DEG

      a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
      c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

      #      d_mi = RMILES * c          # delta between the two points in miles
      #      d_km = RKM * c             # delta in kilometers
      #      d_feet = RFEET * c         # delta in feet
      d_meters = RMETERS * c     # delta in meters
      return d_meters
    end
    
  end
end
