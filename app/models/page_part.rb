# frozen_string_literal: true

class PagePart < ActiveRecord::Base
  belongs_to :template_element
  scope :sort_by_index, -> { order(index: :asc) }

  after_save :create_positions

  def create_positions
    Position.create_positions to_s
  end

  def to_s
    text
  end
end
