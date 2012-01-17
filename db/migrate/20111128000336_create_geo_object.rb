class CreateGeoObject < ActiveRecord::Migration
  def change
    create_table :geo_objects do |t|
      t.float :latitude, :longitude
      t.timestamps
    end
  end
end
