class AddSendDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :send_date, :date
  end
end
