class AddDataToGeoObjects < ActiveRecord::Migration
  def change
    add_column :geo_objects, :data, :text
  end
end
