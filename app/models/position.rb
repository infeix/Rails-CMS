# frozen_string_literal: true

class Position < ActiveRecord::Base
  belongs_to :content_part, optional: true
  belongs_to :page_part, optional: true
  belongs_to :template_element, optional: true
  validates :name, uniqueness: true
  scope :sort_by_name, ->() { order(:name) }

  def owner
    return content_part if content_part
    return page_part if page_part
    return template_element if template_element
  end

  def to_s
    name
  end

  def self.create_positions(text, hash = { content_part: nil, page_part: nil, template_element: nil })
    count = 0
    positions = Position.parse_positions(text)
    positions.each do |position_name|
      position = Position.find_by(name: position_name)
      unless position
        position = Position.new(name: position_name)
        position.content_part = hash[:content_part]
        position.page_part = hash[:page_part]
        position.template_element = hash[:template_element]
        position.save!
        count +=1
      end
      if position.owner.nil?
        position.content_part = hash[:content_part]
        position.page_part = hash[:page_part]
        position.template_element = hash[:template_element]
        position.save!
        count +=1
      end
    end
    count
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
      positions.push position_name
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
