
class ContentPartsPage < ActiveRecord::Base
  belongs_to :page
  belongs_to :content_part
end
