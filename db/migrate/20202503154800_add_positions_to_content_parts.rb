# frozen_string_literal: true
# frozen_string_literal: true

class Position < ActiveRecord::Base

  validates :name, uniqueness: true

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

  def self.create_positions(text)
    positions = []
    Position.parse_positions(text).each do |position_name|
      Position.find_or_create_by(name: position_name)
      positions.push position_name
    end
    positions
  end
end

class ContentPart < ActiveRecord::Base

  belongs_to :template_element, optional: true

  before_save :create_positions
  before_save :set_parent
  after_save :update_parents

  def create_positions
    positions_array = Position.create_positions(self.text)
    self.positions = positions_array.join(';')
  end

  def set_parent
    parents = ContentPart.where("positions like '%#{self.position}%'")

    binding.pry if parents.count > 1
    if parents.count == 1
      cp = parents.first
      temp_positions = Position.parse_positions cp.to_s
      if temp_positions.include?(self.position)
        self.parent_id = cp.id
      end
    end
  end

  def update_parents
    ContentPart.where("positions like '%#{self.position}%'").each do |cp|
      temp_positions = Position.parse_positions cp.to_s
      cp.save if temp_positions.include?(position)
    end
  end

  def to_s
    text
  end
end

class Page < ContentPart
end

class Textelement < ContentPart
  def to_s
    if template_element && template_element.html_parts.all.count > 1 then
      template_element.html_parts[0].to_s +
        text +
        template_element.html_parts[1].to_s
    else
      text
    end
  end
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
  has_many :page_parts, -> { sort_by_index }, dependent: :destroy
  has_many :html_parts, -> { sort_by_index }, dependent: :destroy
  has_many :css_parts, -> { sort_by_index }, dependent: :destroy
end

class PagePart < ActiveRecord::Base
  belongs_to :template_element
  scope :sort_by_index, -> { order(index: :asc) }
end

class HtmlPart < PagePart
end

class CssPart < PagePart
end

class AddPositionsToContentParts < ActiveRecord::Migration[5.1]
  def change
    add_column :content_parts, :positions, :string
    add_reference :content_parts, :parent

    reversible do |dir|
      dir.up do
        ContentPart.all.each do |cp|
          cp.save
        end
        ContentPart.all.each do |cp|
          cp.save
        end
      end

      dir.down do
        #
      end
    end
  end
end
