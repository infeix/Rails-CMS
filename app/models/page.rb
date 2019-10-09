# frozen_string_literal: true

class Page < ActiveRecord::Base
  belongs_to :template_element, optional: true
  has_many :articles, -> { order(index: :asc) }, dependent: :nullify
  has_and_belongs_to_many :content_parts, -> { order(index: :asc) }, optional: true
  scope :sort_by_id, -> { order(id: :asc) }
  validates :path, presence: true

  def textelements
    content_parts.where(type: "Textelement").order(index: :asc)
  end

  def url
    "/pages/#{path}"
  end

  def render_head
    rendered = "<!DOCTYPE html><html lang=\"de\"><head>"
    if template_element.present?
      rendered += template_element.render_head(textelements)
    end
    "#{rendered}</head>"
  end

  def render(notice = nil, alert = nil, user_signed_in = false)
    rendered = render_head
    rendered += "<body>".html_safe
    if template_element.present?
      if content_parts.any?
        rendered += template_element.render textelements.all, content_parts.where.not(type: "Textelement")
      else
        rendered += template_element.render
      end
    elsif content_parts.any?
      rendered += render_content_parts
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

  def render_content_parts
    html = ''
    content_parts.each do |content_part|
      html += content_part.to_s
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

  def self.render_dropdown(element, property, selected)
    html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\">"
    Page.sort_by_name.each do |page|
      if selected.eql? page.name
        html_result = "#{html_result}<option selected>#{page.name}</option>"
      else
        html_result = "#{html_result}<option>#{page.name}</option>"
      end
    end
    html_result = "#{html_result}</select>"
    html_result.html_safe
  end

end
