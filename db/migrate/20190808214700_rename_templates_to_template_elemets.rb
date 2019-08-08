class RenameTemplatesToTemplateElemets < ActiveRecord::Migration[5.1]
  def change
    rename_table :templates, :template_elements
    rename_column :pages, :template_id, :template_element_id
    rename_column :page_parts, :template_id, :template_element_id
    rename_column :articles, :template_id, :template_element_id
  end
end
