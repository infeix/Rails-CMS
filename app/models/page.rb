# frozen_string_literal: true

class Page < ActiveRecord::Base
  belongs_to :template_element, optional: true
  has_many :articles, -> { order(index: :asc) }, dependent: :nullify
  has_many :text_articles, -> { where(type: "Textelement").order(index: :asc) }, foreign_key: "page_id", class_name: "Textelement", dependent: :nullify
  scope :sort_by_id, -> { order(id: :asc) }
  validates :path, presence: true

  def url
    "/pages/#{path}"
  end

  def render_head
    rendered = "<!DOCTYPE html><html lang=\"de\"><head>"
    if template_element.present?
      rendered += template_element.render_head(text_articles)
    end
    "#{rendered}</head>"
  end

  def render(notice = nil, alert = nil, user_signed_in = false)
    rendered = render_head
    rendered += "<body>".html_safe
    if template_element.present?
      if articles.any?
        rendered += template_element.render text_articles.all, articles.all
      else
        rendered += template_element.render
      end
    elsif articles.any?
      rendered += render_articles
    else
      rendered += text
    end
    fixed_menu = "<div class=\"pure-menu-fixed notice\">".html_safe
    fixed_menu += "<p class=\"notice\">#{notice}</p>".html_safe if notice.present?
    fixed_menu += "<a class=\"pure-button pure-button-primary\" href=\"/overviews\">Admin Backend</a>".html_safe if user_signed_in
    fixed_menu += "<p class=\"alert\">#{alert}</p>".html_safe if alert.present?
    fixed_menu += "</div>".html_safe
    rendered = rendered.gsub("<body>", "<body> #{fixed_menu}").html_safe
    "#{rendered}</body></html>".html_safe
  end

  def render_articles
    html = ''
    articles.each do |article|
      html += article.to_s
    end
    html
  end

  def to_s
    text
  end

  def to_param
    path
  end

  def self.editingPage
    Page.where(edit_filter: 1).first
  end
end
