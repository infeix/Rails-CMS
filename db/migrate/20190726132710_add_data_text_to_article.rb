class AddDataTextToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :data_text, :string
  end
end
