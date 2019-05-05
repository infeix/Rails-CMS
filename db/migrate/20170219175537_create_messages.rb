class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :msg
      t.string :name
      t.string :email

      t.timestamps null: false
    end
  end
end
