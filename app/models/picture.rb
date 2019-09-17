# frozen_string_literal: true

class Picture < ContentPart
  def render
    to_s
  end

  def to_s
    "<img src=\"#{image.url}\" alt=\"Image\">"
  end
end
