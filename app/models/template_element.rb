# frozen_string_literal: true

class TemplateElement < ActiveRecord::Base
  has_many :pages, dependent: :nullify
  has_many :articles, dependent: :nullify
  has_many :content_parts, dependent: :nullify
  has_many :page_parts, -> { sort_by_index }, dependent: :destroy
  has_many :html_parts, -> { sort_by_index }, dependent: :destroy
  has_many :css_parts, -> { sort_by_index }, dependent: :destroy
  scope :sort_by_id, ->() { order(:id) }
  scope :sort_by_title, ->() { order(:title) }

  accepts_nested_attributes_for :html_parts
  accepts_nested_attributes_for :css_parts

  after_save :create_positions

  def create_positions
    Position.create_positions reder_meta, template_element: self
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

  def positions(roll = nil)
    positions = []
    Position.parse_positions reder_meta, positions
    html_parts.each do |html_part|
      Position.parse_positions html_part.to_s, positions
    end
    positions = Position.filter_positions positions, roll unless roll.nil?
    positions
  end

  def render_head(page = nil)
    parts = page&.content_parts || []
    html = "#{render_css}#{reder_meta}\n"

    parts.each do |article|
      html = render_article article, html
    end
    html = Position.replace html, 'admin_page_name', page.name.underscore.gsub(' ','_')
    Position.all.each do |position|
      html = Position.clear_blank position, html
    end
    html
  end

  def reder_meta
    html = meta || ''
    html
  end

  def render_css
    html = ''
    css_parts.each do |css|
      html += "<style>\n#{css}\n</style>"
    end
    html
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

  def render(page)
    parts = page&.content_parts&.sort_by_index || []
    html = ''
    html_parts.each do |part|
      html += part.to_s
    end
    parts.each do |article|
      html = render_article article, html
    end
    Position.replace html, 'admin_page_name', page.name.underscore.gsub(' ','_')
    Position.all.each do |position|
      html = Position.clear_blank position, html
    end
    html
  end

  def render_article(article, render_value = "")
    return nil unless article
    render_value = Position.replace render_value, article&.position, article&.render
  end

  def self.render_dropdown(element, property, selected)
    html_result = ""
    is_selected = false
    TemplateElement.sort_by_title.each do |template|
      next if template&.title.blank?
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
