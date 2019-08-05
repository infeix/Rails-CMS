class AddEditToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :edit_filter, :integer
  end
end
