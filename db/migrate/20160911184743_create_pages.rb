class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :text
      t.string :path

      t.timestamps null: false
    end
  end
end
