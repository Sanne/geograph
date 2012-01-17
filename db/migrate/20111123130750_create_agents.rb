class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :status

      t.timestamps
    end
  end
end
