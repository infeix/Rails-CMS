# frozen_string_literal: true

class ContentPart < ActiveRecord::Base

  belongs_to :template_element, optional: true
  belongs_to :page, optional: true
  has_and_belongs_to_many :pages, optional: true
  before_destroy do
    self.pages.clear
  end

  def children(page)
    children_array = self.children_parts&.split(';') || []
    return ContentPart.none unless children_array.any?
    content_parts = ContentPart.includes(:pages).where(pages: {id: page.id})
    content_parts.where('"content_parts"."id" IN (?)', children_array)
  end

  def make_a_copy(page, recursion = true)
    non_copy = ["PdfFile", "JsFile", "CssFile", "VideoElement", "Picture"]
    unless non_copy.include?(type)
      new_part = ContentPart.new
      new_part.template_element = template_element
      new_part.position = position
      new_part.text= text
      new_part.positions = positions
      new_part.title= title
      new_part.code= code
      new_part.index= index
      new_part.type= type
      new_part.target_path= target_path
      new_part.data_text= data_text
      new_part.children_parts= children_parts
      new_part.page = page
      new_part.save!
      new_part.pages << page
      if recursion
        children(page).each do |child|
          child.make_a_copy(page)
        end
      end
      return new_part
    else
      self.page = nil
      unless pages.include?(page)
        self.pages << page
      end
      self.save!
      return self
    end
  end
end

class Page < ActiveRecord::Base
  has_and_belongs_to_many :content_parts, optional: true
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

class TemplateElement < ActiveRecord::Base
end

class SplitContentParts < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        ContentPart.all.each do |cp|
          if cp.pages.count > 1
            unless ["PdfFile", "JsFile", "CssFile", "VideoElement", "Picture"].include?(cp.type)
              cp.pages.each do |page|
                cp.make_a_copy(page)
              end
              cp.destroy
            end
          elsif cp.pages.count == 0
            cp.destroy
          end
        end
      end

      dir.down do
        #
      end
    end
  end
end