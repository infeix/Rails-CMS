class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :title

      t.timestamps null: false
    end
    add_reference :page_parts, :template, index: true, foreign_key: true
    add_reference :pages, :template, index: true, foreign_key: true
    add_reference :articles, :template, index: true, foreign_key: true
  end
end
