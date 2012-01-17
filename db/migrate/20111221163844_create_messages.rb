class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :name
      t.integer :count, :execution_id
      t.timestamps
    end
  end
end
