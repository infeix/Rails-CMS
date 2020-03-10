# frozen_string_literal: true

class Wordelement < ContentPart
  def to_s
    if template_element && template_element.html_parts.all.count > 1 then
      template_element.html_parts[0].to_s +
        text +
        template_element.html_parts[1].to_s
    else
      text
    end
  end
end
