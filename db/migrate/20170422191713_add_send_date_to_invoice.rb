class AddSendDateToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :send_date, :date
  end
end
