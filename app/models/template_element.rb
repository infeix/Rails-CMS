# frozen_string_literal: true

class TemplateElement < ActiveRecord::Base
  has_many :pages, dependent: :nullify
  has_many :articles, dependent: :nullify
  has_many :content_parts, dependent: :nullify
  has_many :page_parts, -> { sort_by_index }, dependent: :destroy
  has_many :html_parts, -> { sort_by_index }, dependent: :destroy
  has_many :css_parts, -> { sort_by_index }, dependent: :destroy
  scope :sort_by_id, ->() { order(:id) }

  accepts_nested_attributes_for :html_parts
  accepts_nested_attributes_for :css_parts

  after_save :create_positions

  def create_positions
    Position.create_positions meta
  end

  def last_html_part
    html_parts.find_by is_last: true
  end

  def render_head(parts = [])
    html = "#{render_css}#{reder_meta}\n"

    parts.each do |article|
      html = render_article article, html
    end
    Position.all.each do |position|
      html = clear_blank_position position, html
    end
    html
  end

  def reder_meta
    meta if meta.present?
  end

  def render_css
    html = ''
    css_parts.each do |css|
      html += "<style>\n#{css}\n</style>"
    end
    html
  end

  def render(text_parts = [], parts = [])
    html = ''
    html_parts.each do |part|
      html += part.to_s
    end
    text_parts.each do |article|
      html = render_article article, html
    end
    parts.each do |article|
      html = render_article article, html
    end
    Position.all.each do |position|
      html = clear_blank_position position, html
    end
    html
  end

  def render_article(article, render_value = "")
    return nil unless article
    replace_title_pattern = "{{#{article.title}}}"
    replace_pattern = "{{#{article.position}}}"

    if render_value.include? replace_title_pattern
      render_value = render_value.gsub(replace_title_pattern, "#{article.render}#{replace_title_pattern}")
      return render_value
    elsif render_value.include? replace_pattern
      render_value = render_value.gsub(replace_pattern, "#{article.render}#{replace_pattern}")
      return render_value
    end

    render_value
  end

  def clear_blank_position(position, render_value = "")
    return nil unless position
    replace_pattern = "{{#{position}}}"

    if render_value.include? replace_pattern
      render_value = render_value.gsub(replace_pattern, '')
      return render_value
    end

    render_value
  end

  def last_index_of(kind)
    if kind.equal? :html_part
      html_parts&.last&.index || 1
    else
      css_parts&.last&.index || 1
    end
  end

  def self.render_dropdown(element, property, selected)
    html_result = ""
    is_selected = false
    TemplateElement.all.each do |template|
      next if template&.title.blank?
      if selected && selected.eql?(template.title)
        html_result = "#{html_result}<option  value=\"#{template.id}\" selected>#{template.title}</option>"
        is_selected = true
      else
        html_result = "#{html_result}<option value=\"#{template.id}\">#{template.title}</option>"
      end
    end

    if is_selected
      html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\"><option value=\"nil\">Standard</option>#{html_result}"
    else
      html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\"><option value=\"nil\" selected>Standard</option>#{html_result}"
    end
    html_result = "#{html_result}</select>"
    html_result.html_safe
  end
end
