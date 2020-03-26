# frozen_string_literal: true

class ContentPart < ActiveRecord::Base
  FILES = ["PdfFile", "JsFile", "CssFile", "VideoElement", "Picture"]

  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  mount_uploader :pdf, PdfUploader
  mount_uploader :css_file, CssFileUploader
  mount_uploader :js_file, JsFileUploader

  belongs_to :template_element, optional: true
  has_many :children, dependent: :nullify, class_name: "ContentPart", foreign_key: "parent_id"
  belongs_to :parent, class_name: "ContentPart", foreign_key: "parent_id", optional: true
  has_and_belongs_to_many :pages, optional: true
  before_destroy do
    pages.clear
  end

  scope :sort_by_index, -> { order(index: :asc) }
  scope :sort_by_title, -> { order(title: :asc) }
  scope :files, -> { where('"content_parts"."type" IN (?)', FILES) }

  validates :type, presence: true

  before_save :define_position
  before_save :set_parent
  before_save :collect_children
  before_save :create_positions
  after_save :collect_pages
  after_save :update_parents

  def define_position
    self.position = title if self.position.eql? "no_position"
  end

  def create_positions
    positions_array = Position.create_positions to_s
    self.positions = positions_array.join(';')
  end

  def collect_children
    collected_children = []
    temp_positions = Position.parse_positions to_s
    temp_positions.each do |position|
      collected_children += ContentPart.where(position: position).pluck(:id)
    end
    self.children_parts = collected_children.join(';')
  end

  def set_parent
    parents = ContentPart.where("positions like '%#{self.position}%'")

    if parents.count == 1
      cp = parents.first
      temp_positions = Position.parse_positions cp.to_s
      if temp_positions.include?(self.position)
        self.parent_id = cp.id
      end
    end
  end

  def update_parents
    ContentPart.where("positions like '%#{self.position}%'").each do |cp|
      temp_positions = Position.parse_positions cp.to_s
      cp.save if temp_positions.include?(position)
    end
  end

  def collect_pages
    return true unless ContentPart::FILES.include?(type)
    Page.all.each do |page|
      unless self.pages.include?(page)
        self.pages << page
     end
    end
  end

  def positions_array
    return [] if positions.blank?
    positions.split(";")
  end

  def filtered_positions(roll = nil, arg_positions = [])
    arg_positions = (arg_positions + self.positions_array).uniq
    arg_positions = Position.filter_positions arg_positions, roll unless roll.nil?
    arg_positions
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
    # binding.pry if (title.eql?("Test") || type.eql?("Textelement")) && !html.include?("<meta ")
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

  def self.render_dropdown(element, property, selected, target_type)
    html_result = ""
    is_selected = false
    TemplateElement.sort_by_title.each do |template|
      next if template&.title.blank?
      next unless template&.target_type.blank? || template&.target_type.include?(target_type)
      if selected && selected.eql?(template.title)
        html_result = "#{html_result}<option  value=\"#{template.id}\" selected>#{template.title}</option>"
        is_selected = true
      else
        html_result = "#{html_result}<option value=\"#{template.id}\">#{template.title}</option>"
      end
    end

    if is_selected
      html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\"><option value=\"nil\">kein Layout</option>#{html_result}"
    else
      html_result = "<select id=\"#{element}_#{property}\" name=\"#{element}[#{property}]\"><option value=\"nil\" selected>kein Layout</option>#{html_result}"
    end
    html_result = "#{html_result}</select>"
    html_result.html_safe
  end

  def self.current_editing_one
    ContentPart.where(edit_filter: 1).first
  end
end
