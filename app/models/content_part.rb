# frozen_string_literal: true

class ContentPart < ActiveRecord::Base
  FILES = ["PdfFile", "JsFile", "CssFile", "VideoElement", "Picture"]

  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  mount_uploader :pdf, PdfUploader
  mount_uploader :css_file, CssFileUploader
  mount_uploader :js_file, JsFileUploader

  belongs_to :template_element, optional: true
  belongs_to :page, optional: true

  scope :sort_by_index, -> { order(index: :asc) }
  scope :sort_by_title, -> { order(title: :asc) }
  scope :files, -> { where('"content_parts"."type" IN (?)', ContentPart::FILES) }

  validates :type, presence: true

  before_save :define_position
  before_save :collect_children
  before_save :create_positions

  def define_position
    self.position = self.title if self.position.blank? || self.position.eql?("no_position")
  end

  def create_positions
    positions_array = Position.create_positions(self.to_s)
    self.positions = positions_array.join(';')
  end

  def collect_children
    collected_children = []
    positions = Position.parse_positions to_s
    positions.each do |position|
      collected_children += ContentPart.where(page: page, position: position)
                                       .or(ContentPart.where(page: nil, position: position))
                                       .sort_by_index.pluck(:id)
    end
    self.children_parts = collected_children.join(';')
  end

  def positions(roll = nil, positions = [])
    positions = Position.parse_positions to_s, positions
    positions = Position.filter_positions positions, roll unless roll.nil?
    positions
  end

  def children(page)
    children_array = self.children_parts&.split(';') || []
    return ContentPart.none unless children_array.any?
    content_parts = ContentPart.where(page: page).or(ContentPart.where(page: nil))
    content_parts.where('"content_parts"."id" IN (?)', children_array)
  end

  def make_a_copy(page, recursion = true)
    non_copy = ContentPart::FILES
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
      if recursion
        children(page).each do |child|
          child.make_a_copy(page)
        end
      end
      return new_part
    else
      return self
    end
  end

  def render(page, html)
    replace_title_pattern = "{{#{title}}}"
    replace_pattern = "{{#{position}}}"

    if html.include? replace_title_pattern
      html = html.gsub(replace_title_pattern, "#{to_s}#{replace_title_pattern}")
      html = render_children(page, html)
    elsif html.include? replace_pattern
      html = html.gsub(replace_pattern, "#{to_s}#{replace_pattern}")
      html = render_children(page, html)
    end
    html
  end

  def render_children(page, html)
    children(page).each do |child|
      html = child.render(page, html)
    end

    html
  end

  def url
    if image.file
      image.url
    elsif pdf.file
      pdf.url
    elsif video.file
      video.url
    elsif css_file.file
      css_file.url
    elsif js_file.file
      js_file.url
    end
  end

  def path
    if image.file
      image.file.file
    elsif pdf.file
      pdf.file.file
    elsif video.file
      video.file.file
    elsif css_file.file
      css_file.file.file
    elsif js_file.file
      js_file.file.file
    end
  end

  def is_file?
    FILES.include?(type)
  end

  def to_s
    text
  end

  def self.current_editing_one
    ContentPart.where(edit_filter: 1).first
  end
end
