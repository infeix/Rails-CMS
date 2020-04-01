# frozen_string_literal: true

class AddPageToContentParts < ActiveRecord::Migration[5.1]
  def change
    add_reference :content_parts, :page
  end
end
