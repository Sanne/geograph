class GeoObject < ActiveRecord::Base
  serialize :data, Hash
  belongs_to :geo_referenced, :polymorphic => true
end
