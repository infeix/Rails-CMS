# frozen_string_literal: true

class ContentPart < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  mount_uploader :pdf, PdfUploader
  mount_uploader :css_file, CssFileUploader
  mount_uploader :js_file, JsFileUploader

  belongs_to :template_element, optional: true
  has_many :content_part_pages
  has_many :pages,  through: :content_part_pages
  scope :sort_by_index, -> { order(index: :asc) }

  before_save :create_position
  before_save :collect_children
  after_save :create_positions

  def create_position
    self.position = title if self.position.eql? "no_position"
  end

  def create_positions
    count = Position.create_positions to_s, content_part: self
    if count > 0
      position = Position.find_by(name: self.position)
      if position&.content_part
        content_part = ContentPart.find_by(id: position.content_part_id)
        content_part.save!
      end
    end
  end

  def collect_children
    children = []
    positions = Position.parse_positions to_s
    positions.each do |position|
      children += ContentPart.where(position: position).pluck(:id)
    end
    self.children_parts = children.join(';')
  end

  def children
    return ContentPart.none if self.children_parts.blank?
    children_array = self.children_parts.split(';')
    ContentPart.where("id IN (?)", children_array).sort_by_index
  end

  # def render
  #   template.present? ? "#{template.html_begin} #{text} #{template.html_end}" : text
  # end

  def render
    to_s
  end

  def to_s
    text
  end

  def self.currentEditingOne
    ContentPart.where(edit_filter: 1).first
  end
end
