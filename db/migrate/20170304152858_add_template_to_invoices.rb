class AddTemplateToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :document_template
  end
end
