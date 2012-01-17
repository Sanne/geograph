class GeoObjectFenix < FenixGeoObject
  class << self

    def create attrs = {}
      instance = nil
      manager = CloudTmTransactionManager.manager
      manager.withTransaction do

        instance = FenixGeoObject.new
        attrs.each do |attr, value|
          instance.send("set#{attr.to_s.camelize}", value)
        end
        manager.save instance
        instance.set_root manager.getRoot
        java.lang.Void
      end
      instance
    end

  end
end
