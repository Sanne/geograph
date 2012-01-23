module Fenix
  class GeoObject
    def to_json
      {
        :id => oid,
        :latitude => latitude.to_s,
        :longitude => longitude.to_s
      }.to_json
    end

    class << self

      def create attrs = {}
        manager = CloudTm::TxSystem.getManager
        manager.withTransaction do

          instance = Fenix::GeoObject.new
          attrs.each do |attr, value|
            instance.send("#{attr}=", value)
          end
          manager.save instance
          instance.set_root manager.getRoot
          instance.to_json
        end
      end

      def all
        manager = CloudTm::TxSystem.getManager
        manager.withTransaction do
          _geo_objects = manager.getRoot.getGeoObjects
          _geo_objects.map(&:to_json)
        end
      end

    end
  end
end