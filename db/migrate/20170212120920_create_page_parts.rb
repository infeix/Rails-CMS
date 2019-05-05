class CreatePageParts < ActiveRecord::Migration[5.0]
  def change
    create_table :page_parts do |t|
      t.string :title
      t.integer :index
      t.text :text
      t.boolean :is_last, default: false
      t.string :type

      t.timestamps null: false
    end
  end
end
