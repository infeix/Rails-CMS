class PagePart < ActiveRecord::Base
  def to_s
    text
  end
end
