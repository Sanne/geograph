class AddPolymorphicGeoReferenced < ActiveRecord::Migration
  def change
    add_column :geo_objects, :geo_referenced_id, :integer
    add_column :geo_objects, :geo_referenced_type, :string
  end
end
