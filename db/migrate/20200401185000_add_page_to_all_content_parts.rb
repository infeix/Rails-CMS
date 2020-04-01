# frozen_string_literal: true

class ContentPart < ActiveRecord::Base

  belongs_to :page, optional: true
  has_and_belongs_to_many :pages, optional: true

  before_save :select_page

  def select_page
    if self.pages.count == 1
      self.page = self.pages.first
    end
  end
end

class Page < ActiveRecord::Base
end

class Textelement < ContentPart
end

class Wordelement < ContentPart
end

class Urlelement < ContentPart
end

class Picture < ContentPart
end

class JsFile < ContentPart
end

class CssFile < ContentPart
end

class PdfFile < ContentPart
end

class AddPageToAllContentParts < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        ContentPart.all.each do |cp|
          cp.save!
        end
      end

      dir.down do
        #
      end
    end
  end
end