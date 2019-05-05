class AddToAndFromToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :to
    add_reference :invoices, :from
  end
end
