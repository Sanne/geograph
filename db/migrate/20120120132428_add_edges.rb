class AddEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.integer :geo_object_id, :connection_id
    end
  end
end
