class AddToAndFromToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :to
    add_reference :invoices, :from
  end
end
