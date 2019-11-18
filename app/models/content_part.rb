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

  before_save :create_position
  before_save :collect_children
  after_save :create_positions

  def create_position
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

  def children
    children_array = self.children_parts.split(';')
    ContentPart.where("id IN (?)", children_array)
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
