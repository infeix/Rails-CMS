class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :lang
      t.string :name
      t.boolean :is_admin

      t.timestamps null: false
    end
  end
end
