class AddEditFilterToContentPart < ActiveRecord::Migration[5.1]
  def change
    add_column :content_parts, :edit_filter, :integer
  end
end
