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

require 'haversine_distance'

module CloudTm
  class GeoObject
    include CloudTm::Model

    def attributes_to_hash
      {
        :id => oid,
        :latitude => latitude.to_s,
        :longitude => longitude.to_s,
        :data => {:type => type, :body => body}
      }
    end

    def to_json
      attributes_to_hash.to_json
    end

    def destroy
      manager.getRoot.removeGeoObjects(self)
    end

    def remove_edges
      getIncoming.each do |inc|
        removeIncoming(inc)
      end
      getOutcoming.each do |out|
        removeOutcoming(out)
      end
    end

    def renew_edges(distance)
      remove_edges
      new_neighbors = neighbors(distance)
      new_neighbors.each do |geo_obj|
        addIncoming(geo_obj)
        geo_obj.addIncoming(self)
      end
    end

    def neighbors(distance)
      CloudTm::GeoObject.all.select do |geo_obj|
        (self != geo_obj) and
          (HaversineDistance.calculate(self, geo_obj) <= distance)
      end
    end

    def edges_for_percept
      edges = []
      getIncoming.each do |geo_obj|
        edges << {:from => {
            :id => self.oid,
            :latitude => self.latitude.to_s,
            :longitude => self.longitude.to_s
          }, :to => {
            :id => geo_obj.oid,
            :latitude => geo_obj.latitude.to_s,
            :longitude => geo_obj.longitude.to_s
          }}
      end
      edges
    end

    class << self

      def find(oid)
        _oid = oid.to_i
        all.each do |geo_obj|
          return geo_obj if geo_obj.oid == _oid
        end
        return nil
      end
      
      def create_with_root attrs = {}, &block
        create_without_root(attrs) do |instance|
          instance.set_root manager.getRoot
        end
      end

      alias_method_chain :create, :root

      def all
        manager.getRoot.getGeoObjects
      end

    end
  end
end