# frozen_string_literal: true

class Article < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
  mount_uploader :pdf, PdfUploader

  belongs_to :template_element, optional: true
  belongs_to :page, optional: true
  scope :sort_by_index, -> { order(index: :asc) }

  after_save :create_positions

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
end
