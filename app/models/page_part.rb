# frozen_string_literal: true

class PagePart < ActiveRecord::Base
  belongs_to :template
  def to_s
    text
  end
end
