class AddOwnerToPositions < ActiveRecord::Migration[5.1]
  def change
    add_reference :positions, :content_part
    add_reference :positions, :page_part
    add_reference :positions, :template_element
  end
end
