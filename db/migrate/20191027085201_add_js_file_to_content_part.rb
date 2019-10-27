class AddJsFileToContentPart < ActiveRecord::Migration[5.1]
  def change
    add_column :content_parts, :js_file, :string
  end
end
