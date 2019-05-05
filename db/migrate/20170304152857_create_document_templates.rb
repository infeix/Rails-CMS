class CreateDocumentTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :document_templates do |t|
      t.text :template

      t.timestamps null: false
    end
  end
end
