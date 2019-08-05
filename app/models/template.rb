# frozen_string_literal: true

class Template < ActiveRecord::Base
  has_many :pages
  has_many :articles
  has_many :html_parts, -> { sort_by_index }
  has_many :css_parts, -> { sort_by_index }

  accepts_nested_attributes_for :html_parts
  accepts_nested_attributes_for :css_parts

  def last_html_part
    html_parts.find_by is_last: true
  end

  def render_head
    "#{render_css}#{reder_meta}\n"
  end

  def render(parts = [])
    "#{render_articles(parts)}"
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

  def render_articles(parts)
    html = ''
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
    replace_pattern = "{{#{article.position}}}"

    if render_value.include? replace_pattern
      render_value = render_value.gsub(replace_pattern, article.to_s)
      return render_value
    else
      html_parts.each do |part|
        if part.to_s.include? replace_pattern
          render_value += part.to_s.gsub(replace_pattern, article.to_s)
          return render_value
        end
      end
    end

    "#{render_value}#{article}"
  end

  def clear_blank_position(position, render_value = "")
    return nil unless position
    replace_pattern = "{{#{position}}}"

    if render_value.include? replace_pattern
      render_value = render_value.gsub(replace_pattern, '')
      return render_value
    else
      html_parts.each do |part|
        if part.to_s.include? replace_pattern
          render_value += part.to_s.gsub(replace_pattern, '')
          return render_value
        end
      end
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
end
