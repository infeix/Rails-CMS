class AddCssFileToContentPart < ActiveRecord::Migration[5.1]
  def change
    add_column :content_parts, :css_file, :string
  end
end
