class AddPositionToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :position, :string
  end
end
