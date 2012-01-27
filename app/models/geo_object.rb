class GeoObject < ActiveRecord::Base
  serialize :data, Hash
  belongs_to :geo_referenced, :polymorphic => true

  has_many :edges, :dependent => :delete_all
  has_many :connections, :through => :edges
  has_many :inverse_edges, :class_name => "Edge", :foreign_key => "connection_id"
  has_many :inverse_connections, :through => :inverse_edges, :source => :geo_object
end
