
class ContentPartsPages < ActiveRecord::Base
end

class ContentPartPages < ActiveRecord::Base
end


class CreateContentPartPages < ActiveRecord::Migration[5.1]
  def change
    create_table "content_part_pages" do |t|
      t.timestamps null: false
    end
    add_reference :content_part_pages, :page, index: true, foreign_key: true
    add_reference :content_part_pages, :content_part, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        ContentPartsPages.all.each do |cpp|
          ncpp = ContentPartPages.find_or_create_by(page_id: cpp.page_id, content_part_id: cpp.content_part_id)
        end
      end

      dir.down do
        ContentPartPages.all.each do |cpp|
          ncpp = ContentPartsPages.find_or_create_by(page_id: cpp.page_id, content_part_id: cpp.content_part_id)
        end
      end
    end
  end
end
