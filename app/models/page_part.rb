# frozen_string_literal: true

class PagePart < ActiveRecord::Base
  belongs_to :template_element
  scope :sort_by_index, -> { order(index: :asc) }

  after_save :create_positions

  def make_a_copy(template_element)
    new_page_part = PagePart.new
    new_page_part.title = "#{title}_copy"
    new_page_part.index = index
    new_page_part.text = text
    new_page_part.is_last = is_last
    new_page_part.type = type
    new_page_part.template_element_id = template_element.id
    new_page_part.save!
    new_page_part
  end

  def create_positions
    Position.create_positions to_s
  end

  def to_s
    text
  end
end
