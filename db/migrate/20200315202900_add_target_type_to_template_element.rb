# frozen_string_literal: true

class AddTargetTypeToTemplateElement < ActiveRecord::Migration[5.1]
  def change
    add_column :template_elements, :target_type, :string
  end
end