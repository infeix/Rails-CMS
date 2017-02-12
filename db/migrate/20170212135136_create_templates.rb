class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.text :html_begin
      t.text :html_end

      t.timestamps null: false
    end
  end
end
