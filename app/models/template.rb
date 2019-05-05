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
      html += render_article article
    end
    html
  end

  def render_article(article)
    it_is_rendered = false
    render_value = nil
    html_parts.each do |part|
      if part.to_s.include? "{{artikel_#{article.index}}}"
        render_value = part.to_s.gsub("{{artikel_#{article.index}}}", article.to_s)
        it_is_rendered = true
      end
    end
    render_value = article.to_s || "" unless it_is_rendered
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
