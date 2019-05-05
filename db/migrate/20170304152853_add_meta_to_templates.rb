class AddMetaToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :meta, :text
  end
end
