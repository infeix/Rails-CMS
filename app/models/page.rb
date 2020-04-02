# frozen_string_literal: true

class Page < ActiveRecord::Base
  belongs_to :template_element, optional: true
  has_many :content_parts
  scope :sort_by_id, -> { order(id: :asc) }
  validates :path, presence: true
  validates :path, uniqueness: true

  def all_content_parts
    ContentPart.where(page: self).or(ContentPart.where(page: nil)).order(index: :asc)
  end

  def type
    "Page"
  end

  def url
    "/pages/#{path}"
  end

  def render_head
    rendered = "<!DOCTYPE html><html lang=\"de\"><head>"
    if template_element.present?
      rendered += template_element.render_head(self, all_content_parts)
    end
    "#{rendered}</head>"
  end

  def render(notice = nil, alert = nil, user_signed_in = false)
    rendered = render_head
    rendered += "<body>".html_safe
    if template_element.present?
      if all_content_parts.any?
        rendered += template_element.render(self, all_content_parts)
      else
        rendered += template_element.render(self)
      end
    elsif all_content_parts.any?
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
    all_content_parts.each do |content_part|
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

  def make_a_copy(page_params)
    editing = Page.current_editing_one
    if editing.present?
      editing.edit_filter = 0
      editing.save!
    end

    new_page = Page.new
    new_page.attributes = self.attributes
    new_page.id = nil
    new_page.assign_attributes(page_params)
    new_page.path = "#{new_page.path}_copy"
    new_page.edit_filter = 1
    new_page.save!
    all_content_parts.each do |part|
      part.make_a_copy(new_page, false)
    end
    new_page
  end

  def self.current_editing_one
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
