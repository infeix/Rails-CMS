
class ContentPartPage < ActiveRecord::Base
end


class DropContentPartPagesTable < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        ContentPartPage.all.each do |cpp|
          cpp.destroy
        end
        drop_table :content_part_pages
      end

      dir.down do
        #
      end
    end
  end
end