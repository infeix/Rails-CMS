# frozen_string_literal: true

class PagePart < ActiveRecord::Base
  belongs_to :template
  scope :sort_by_index, -> { order(index: :asc) }
  def to_s
    text
  end
end
