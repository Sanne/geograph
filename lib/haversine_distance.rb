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
