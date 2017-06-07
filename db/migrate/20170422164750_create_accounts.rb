class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.float :starting_level
      t.string :name

      t.timestamps null: false
    end
  end
end
