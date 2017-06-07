class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :amount
      t.string :unit
      t.string :description
      t.float :price_per_unit
      t.references :invoice

      t.timestamps null: false
    end
  end
end
