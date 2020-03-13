# frozen_string_literal: true

class ContentPart < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  mount_uploader :pdf, PdfUploader
  mount_uploader :css_file, CssFileUploader
  mount_uploader :js_file, JsFileUploader

  belongs_to :template_element, optional: true
  has_and_belongs_to_many :pages, optional: true

  scope :sort_by_index, -> { order(index: :asc) }

  validates :type, presence: true

  before_save :define_position
  before_save :collect_children
  after_save :create_positions

  def define_position
    self.position = title if self.position.eql? "no_position"
  end

  def create_positions
    Position.create_positions to_s
  end

  def collect_children
    children = []
    positions = Position.parse_positions to_s
    positions.each do |position|
      children += ContentPart.where(position: position).pluck(:id)
    end
    self.children_parts = children.join(';')
  end

  def positions(roll = nil, positions = [])
    positions = Position.parse_positions to_s, positions
    positions = Position.filter_positions positions, roll unless roll.nil?
    positions
  end

  def children(page)
    children_array = self.children_parts&.split(';') || []
    return ContentPart.none unless children_array.any?
    content_parts = ContentPart.includes(:pages).where(pages: {id: page.id})
    content_parts.where('"content_parts"."id" IN (?)', children_array)
  end

  def make_a_copy(page, recursion = true)
    non_copy = ["PdfFile", "JsFile", "CssFile", "VideoElement", "Picture"]
    unless non_copy.include?(type)
      new_part = ContentPart.new
      new_part.template_element = template_element
      new_part.position = position
      new_part.text= text
      new_part.title= title
      new_part.code= code
      new_part.index= index
      new_part.type= type
      new_part.target_path= target_path
      new_part.data_text= data_text
      new_part.children_parts= children_parts
      new_part.save!
      new_part.pages << page
      if recursion
        children(page).each do |child|
          child.make_a_copy(page)
        end
      end
      return new_part
    else
      unless pages.include?(page)
        pages << page
      end
      return self
    end
  end

  def render(page, html)
    replace_title_pattern = "{{#{title}}}"
    replace_pattern = "{{#{position}}}"

    if html.include? replace_title_pattern
      html = html.gsub(replace_title_pattern, "#{to_s}#{replace_title_pattern}")
    elsif html.include? replace_pattern
      html = html.gsub(replace_pattern, "#{to_s}#{replace_pattern}")
    end

    children(page).each do |child|
      html = child.render(page, html)
    end

    html
  end

  def to_s
    text
  end

  def self.current_editing_one
    ContentPart.where(edit_filter: 1).first
  end
end
