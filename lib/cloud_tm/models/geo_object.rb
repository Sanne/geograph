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

    class << self

      def find(oid)
        _oid = oid.to_i
        all.each do |geo_obj|
          return geo_obj if geo_obj.oid == _oid
        end
        return nil
      end
      
      def create_with_root attrs = {}, &block
        create_without_root do |instance|
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