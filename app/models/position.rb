# frozen_string_literal: true

class Position < ActiveRecord::Base

  validates :name, uniqueness: true
  scope :sort_by_name, ->() { order(:name) }

  def usage_count
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

  def self.create_positions(text)
    return unless text&.include? '{{'
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
