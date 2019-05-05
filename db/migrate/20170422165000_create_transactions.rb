class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.float :total
      t.string :name
      t.date :invoice_date

      t.timestamps null: false
    end
    add_reference :transactions, :from, references: :accounts, index: true
    add_foreign_key :transactions, :accounts, column: :from_id
    add_reference :transactions, :to, references: :accounts, index: true
    add_foreign_key :transactions, :accounts, column: :to_id
  end
end
