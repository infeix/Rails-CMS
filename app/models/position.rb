# frozen_string_literal: true

class Position < ActiveRecord::Base

  validates :name, uniqueness: true

  def self.render_dropdown(element, property)
    html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\">"
    Position.all.each do |position|
      html_result = "#{html_result}<option>#{position.name}</option>"
    end
    html_result = "#{html_result}</select>"
    html_result.html_safe
  end

  def self.create_positions(text)
    return unless text.include? '{{'
    text_parts = text.split('{{').drop(1)
    text_parts.each do |text_part|
      next unless text_part.include? '}}'
      position_name = text_part.split('}}').first
      Position.find_or_create_by(name: position_name)
    end
  end

  def to_s
    name
  end
end
