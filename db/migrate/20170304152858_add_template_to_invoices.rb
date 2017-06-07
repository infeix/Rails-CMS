class AddTemplateToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :document_template
  end
end
