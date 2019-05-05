class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :phone
      t.string :mail
      t.string :bank_account_nr
      t.string :bank_name
      t.string :tax_nr

      t.timestamps null: false
    end
  end
end
