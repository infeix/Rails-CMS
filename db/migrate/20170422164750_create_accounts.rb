class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.float :starting_level
      t.string :name

      t.timestamps null: false
    end
  end
end
