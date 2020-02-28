# frozen_string_literal: true

class Position < ActiveRecord::Base

  validates :name, uniqueness: true
  scope :sort_by_name, ->() { order(:name) }

  def to_s
    name
  end

  def self.create_positions(text)
    Position.parse_positions(text).each do |position_name|
      Position.find_or_create_by(name: position_name)
    end
  end

  def self.filter_positions(positions = [], roll = nil)
    return positions unless roll
    return positions unless roll.eql? :agent
    allowed_positions = []
    positions.each do |position|
      allowed_positions.push position unless position.include? "admin:"
    end
    allowed_positions
  end

  def self.parse_positions(text, positions = [])
    return [] unless text&.include? '{{'
    text_parts = text.split('{{').drop(1)
    text_parts.each do |text_part|
      next unless text_part.include? '}}'
      position_name = text_part.split('}}').first
      positions.push position_name unless positions.include? position_name
    end
    positions
  end

  def self.render_dropdown(element, property, selected)
    html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\">"
    if selected.eql? 'no_position'
      html_result = "#{html_result}<option selected>no_position</option>"
    else
      html_result = "#{html_result}<option>no_position</option>"
    end
    Position.where.not(name: 'no_position').sort_by_name.each do |position|
      if selected.eql? position.name
        html_result = "#{html_result}<option selected>#{position.name}</option>"
      else
        html_result = "#{html_result}<option>#{position.name}</option>"
      end
    end
    html_result = "#{html_result}</select>"
    html_result.html_safe
  end
end
