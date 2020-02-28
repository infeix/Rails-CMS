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

  def children
    children_array = self.children_parts&.split(';') || []
    ContentPart.where("id IN (?)", children_array)
  end

  def make_a_copy(page, recursion = true)
    new_part = ContentPart.new
    new_part.template_element = template_element
    new_part.position = position
    new_part.text= text
    new_part.title= title
    new_part.code= code
    new_part.index= index
    new_part.image= image
    new_part.pdf= pdf
    new_part.css_file= css_file
    new_part.js_file= js_file
    new_part.video= video
    new_part.type= type
    new_part.target_path= target_path
    new_part.data_text= data_text
    new_part.children_parts= children_parts
    new_part.save!
    new_part.pages << page
    if recursion
      children.each do |child|
        child.make_a_copy(page)
      end
    end
    new_part
  end

  def render
    to_s
  end

  def to_s
    text
  end

  def self.current_editing_one
    ContentPart.where(edit_filter: 1).first
  end
end
