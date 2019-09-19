# frozen_string_literal: true

class Picture < ContentPart
  def render
    to_s
  end

  def to_s
    if template_element && template_element.html_parts.all.count > 1 then
      template_element.html_parts[0].to_s +
        "<img src=\"#{image.url}\" alt=\"Image\">" +
        template_element.html_parts[1].to_s
    else
      "<img src=\"#{image.url}\" alt=\"Image\">"
    end
  end
end
