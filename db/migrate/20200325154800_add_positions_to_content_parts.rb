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

  def create_positions
    positions_array = Position.create_positions(self.to_s)
    self.positions = positions_array.join(';')
  end

  def to_s
    self.text
  end
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
  def to_s
    if template_element && template_element.html_parts.all.count > 3 then
      template_element.html_parts[0].to_s +
        "<a href=\"#{target_path}\" data-target=\"#{target_path}\" data-position=\"#{position}\" #{template_element.meta} #{data_text}>" +
        template_element.html_parts[1].to_s +
        text +
        template_element.html_parts[2].to_s +
        "</a>" +
        template_element.html_parts[3].to_s.html_safe
    elsif template_element && template_element.html_parts.all.count > 1 then
      template_element.html_parts[0].to_s +
        "<a href=\"#{target_path}\" data-target=\"#{target_path}\" data-position=\"#{position}\" #{template_element.meta} #{data_text}>" +
        text +
        "</a>" +
        template_element.html_parts[1].to_s
    else
      "<a href=\"#{target_path}\" #{data_text}>#{text}</a>".html_safe
    end
  end
end

class Picture < ContentPart
  def to_s
    if template_element && template_element.html_parts.all.count > 1 then
      template_element.html_parts[0].to_s +
        "<img src=\"#{image}\" alt=\"Image\">" +
        template_element.html_parts[1].to_s
    else
      "<img src=\"#{image}\" alt=\"Image\">"
    end
  end
end

class JsFile < ContentPart
end

class CssFile < ContentPart
end

class PdfFile < ContentPart
  def to_s
    if template_element && template_element.html_parts.all.count > 3 then
      template_element.html_parts[0].to_s +
        "<a href=\"#{pdf}\" data-target=\"#{target_path}\" data-position=\"#{position}\" #{template_element.meta} #{data_text}>" +
        template_element.html_parts[1].to_s +
        text +
        template_element.html_parts[2].to_s +
        "</a>" +
        template_element.html_parts[3].to_s.html_safe
    else
      "<a href=\"#{pdf}\" #{data_text}>#{text}</a>".html_safe
    end
  end
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

    reversible do |dir|
      dir.up do
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
