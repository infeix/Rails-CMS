class AddTemplateReferenceToArticle < ActiveRecord::Migration
  def change
    add_reference :articles, :template, foreign_key: true
  end
end
