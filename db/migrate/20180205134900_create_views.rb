class CreateViews < ActiveRecord::Migration[5.0]
  def change
    create_table :views do |t|
      t.string :ref
      t.references :page

      t.timestamps null: false
    end
  end
end
