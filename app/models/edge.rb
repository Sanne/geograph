class Edge < ActiveRecord::Base
  belongs_to :geo_object
  belongs_to :connection, :class_name => "GeoObject"
end
