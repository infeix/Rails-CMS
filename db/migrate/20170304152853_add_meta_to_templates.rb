class AddMetaToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :meta, :text
  end
end
