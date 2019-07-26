class AddVideoToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :video, :string
  end
end
