# frozen_string_literal: true

class Article < ActiveRecord::Base
  belongs_to :template
  scope :sort_by_index, -> { order(index: :asc) }

  def render
    template.present? ? "#{template.html_begin} #{text} #{template.html_end}" : text
  end

  def to_s
    text
  end
end
