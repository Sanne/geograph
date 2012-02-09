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