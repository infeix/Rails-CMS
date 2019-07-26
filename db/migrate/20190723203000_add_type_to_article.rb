
class Article < ActiveRecord::Base
end


class AddTypeToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :type, :string
    reversible do |dir|
      dir.up do
        Article.all.each do |article|
          article.type = 'Textelement'
          article.save!
        end
      end

      dir.down do
        #
      end
    end

    add_column :articles, :target_path, :string
  end
end
