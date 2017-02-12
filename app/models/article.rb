# frozen_string_literal: true

class Article < ActiveRecord::Base
  belongs_to :template
  validates :path, presence: true

  def render
    template.present? ? "#{template.html_begin} #{text} #{template.html_end}" : text
  end

  def to_param
    path
  end
end
