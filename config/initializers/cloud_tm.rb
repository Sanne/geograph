require File.join(Rails.root, 'lib', 'cloud_tm', 'framework')

# loading the Fenix Framework
CloudTm::Framework.init(
  :dml => 'geograph.dml',
  :conf => 'infinispan-conf.xml',
  :framework => CloudTm::Config::Framework::FENIX
)


go = Fenix::GeoObject.create({
    :latitude => java.math.BigDecimal.new("45.3422"),
    :longitude => java.math.BigDecimal.new("23.4356")
  })
Rails.logger.debug "Created #{go}"

Fenix::GeoObject.all.each do |geo_object|
  go_des = JSON.parse(geo_object)
  Rails.logger.debug "Created geo object: lat = #{go_des['latitude']} - lon = #{go_des['longitude']}"
end