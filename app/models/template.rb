# frozen_string_literal: true

class Template < ActiveRecord::Base
  has_many :pages
  has_many :articles
  has_many :html_parts
  has_many :css_parts

  def last_html_part
    html_parts.find_by is_last: true
  end

  def flash_messages
    '<p class="notice"><%= notice %></p><p class="alert"><%= alert %></p>'
  end

  def render(arts = [])
    "#{render_css} <body> #{flash_messages} #{render_articles(arts)} #{last_html_part} </body>"
  end

  def render_css
    html = ''
    css_parts.each do |css|
      html += "<style>\n#{css}\n</style></head>\n"
    end
    html
  end

  def render_articles(arts)
    html = ''
    arts.each do |article|
      html += render_article article
    end
    html
  end

  def render_article(article)
    part = html_parts.find_by(index: article.index, is_last: false)
    if part.present?
      "#{part} #{article}"
    else
      article.to_s
    end
  end
end
