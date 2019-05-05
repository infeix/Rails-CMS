class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :text
      t.string :path

      t.timestamps null: false
    end
  end
end
