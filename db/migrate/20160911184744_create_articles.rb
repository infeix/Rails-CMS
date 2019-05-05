class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.text :code
      t.integer :index

      t.timestamps null: false
    end
    add_reference :articles, :page, index: true, foreign_key: true
  end
end
