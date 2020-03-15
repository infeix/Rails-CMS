# frozen_string_literal: true

class Position < ActiveRecord::Base
  def self.parse_positions(text, positions = [])
    return positions unless text&.include? '{{'
    text_parts = text.split('{{').drop(1)
    text_parts.each do |text_part|
      next unless text_part.include? '}}'
      position_name = text_part.split('}}').first
      positions.push position_name unless positions.include? position_name
    end
    positions
  end
end

class ContentPart < ActiveRecord::Base
  FILES = ["PdfFile", "JsFile", "CssFile", "VideoElement", "Picture"]

  before_save :collect_children
  after_save :collect_pages

  def collect_children
    collected_children = []
    positions = Position.parse_positions to_s
    positions.each do |position|
      collected_children += ContentPart.where(position: position).pluck(:id)
    end
    self.children_parts = collected_children.join(';')
  end

  def collect_pages
    return true unless ContentPart::FILES.include?(type)
    Page.all.each do |page|
      unless pages.include?(page)
        pages << page
     end
    end
  end

  def to_s
    text
  end
end

class Page < ContentPart
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

class SaveAllContentParts < ActiveRecord::Migration[5.1]
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