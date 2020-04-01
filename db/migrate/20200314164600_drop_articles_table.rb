
class Article < ActiveRecord::Base
end

class DropArticlesTable < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Article.all.each do |cpp|
          cpp.destroy
        end
        drop_table :articles
      end

      dir.down do
        #
      end
    end
  end
end