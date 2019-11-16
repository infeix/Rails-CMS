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
  after_save :create_positions

  def create_position
    self.position = title if self.position.eql? "no_position"
  end

  def create_positions
    Position.create_positions to_s
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
