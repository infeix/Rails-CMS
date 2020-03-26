# frozen_string_literal: true

class TemplateElement < ActiveRecord::Base
  has_many :pages, dependent: :nullify
  has_many :content_parts, dependent: :nullify
  has_many :page_parts, -> { sort_by_index }, dependent: :destroy
  has_many :html_parts, -> { sort_by_index }, dependent: :destroy
  has_many :css_parts, -> { sort_by_index }, dependent: :destroy
  scope :sort_by_id, ->() { order(:id) }
  scope :sort_by_title, ->() { order(:title) }

  accepts_nested_attributes_for :html_parts
  accepts_nested_attributes_for :css_parts

  after_save :create_positions

  def clear_blank_position(position, render_value = "")
    return nil unless position
    replace_pattern = "{{#{position}}}"

    if render_value.include? replace_pattern
      render_value = render_value.gsub(replace_pattern, '')
      return render_value
    end

    render_value
  end

  def create_positions
    Position.create_positions meta
  end

  def last_html_part
    html_parts.find_by is_last: true
  end

  def last_index_of(kind)
    if kind.equal? :html_part
      html_parts&.last&.index || 1
    else
      css_parts&.last&.index || 1
    end
  end

  def filtered_positions(roll = nil, positions = [])
    positions = Position.parse_positions meta, positions
    html_parts.each do |html_part|
      positions = Position.parse_positions html_part.to_s, positions
    end
    positions = Position.filter_positions positions, roll unless roll.nil?
    positions
  end

  def render_head(page, parts = [])
    html = "#{render_css}#{render_meta}\n"

    parts.each do |part|
      html = part.render(page, html)
    end
    Position.all.each do |position|
      html = clear_blank_position position, html
    end
    html
  end

  def render_meta
    meta if meta.present?
  end

  def render_css
    html = ''
    css_parts.each do |css|
      html += "<style>\n#{css}\n</style>"
    end
    html
  end

  def make_a_copy
    new_template_element = TemplateElement.new
    new_template_element.title = "#{title}_copy"
    new_template_element.meta = meta
    new_template_element.save!

    html_parts.each do |part|
      part.make_a_copy(new_template_element)
    end
    css_parts.each do |part|
      part.make_a_copy(new_template_element)
    end
    new_template_element
  end

  def remove_empty_css
    deleted = false
    css_parts.each do |css|
      if css.text.blank?
        css.destroy
        deleted = true
      end
    end
    deleted
  end

  def render(page, parts = ContentPart.none)
    html = ''
    html_parts.each do |part|
      html += part.to_s
    end
    positions = Position.parse_positions(html)
    positions.each do |position|
      position_parts = parts.where(position: position)
      position_parts.each do |part|
        html = part.render(page, html)
      end
    end
    Position.all.each do |position|
      html = clear_blank_position position, html
    end
    html
  end

  def self.render_dropdown(element, property, selected, target_type)
    html_result = ""
    is_selected = false
    TemplateElement.sort_by_title.each do |template|
      next if template&.title.blank?
      next unless template&.target_type.blank? || template&.target_type.include?(target_type)
      if selected && selected.eql?(template.title)
        html_result = "#{html_result}<option  value=\"#{template.id}\" selected>#{template.title}</option>"
        is_selected = true
      else
        html_result = "#{html_result}<option value=\"#{template.id}\">#{template.title}</option>"
      end
    end

    if is_selected
      html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\"><option value=\"nil\">kein Layout</option>#{html_result}"
    else
      html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\"><option value=\"nil\" selected>kein Layout</option>#{html_result}"
    end
    html_result = "#{html_result}</select>"
    html_result.html_safe
  end
end
