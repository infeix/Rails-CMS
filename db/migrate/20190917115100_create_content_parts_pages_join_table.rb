
class Article < ActiveRecord::Base
end

class ContentPart < ActiveRecord::Base
  has_and_belongs_to_many :pages, optional: true
end

class Textelement < Article
end

class Urlelement < Article
end

class PdfFile < Article
end

class Picture < Article
end

class Page < ActiveRecord::Base
  has_and_belongs_to_many :content_parts, optional: true
end


class CreateContentPartsPagesJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :content_parts do |t|
      t.string :title
      t.text :text
      t.text :code
      t.integer :index
      t.integer :template_element_id
      t.string :position
      t.string :image
      t.string :video
      t.string :type
      t.string :target_path
      t.string :data_text
      t.string :pdf

      t.timestamps null: false
    end

    create_join_table :content_parts, :pages

    reversible do |dir|
      dir.up do
        Article.all.each do |article|
          conten_part = ContentPart.new
          conten_part.title = article.title
          conten_part.text = article.text
          conten_part.code = article.code
          conten_part.index = article.index
          conten_part.template_element_id = article.template_element_id
          conten_part.position = article.position
          conten_part.image = article.image
          conten_part.video = article.video
          conten_part.type = article.type
          conten_part.target_path = article.target_path
          conten_part.data_text = article.data_text
          conten_part.pdf = article.pdf
          conten_part.save!
          if article.page_id
            page = Page.find_by(id: article.page_id)
            conten_part.pages << page
          end
        end
      end

      dir.down do
        #
      end
    end
  end
end