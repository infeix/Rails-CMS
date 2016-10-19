class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.string :picture
      t.text :code
      t.string :path

      t.timestamps null: false
    end
  end
end
