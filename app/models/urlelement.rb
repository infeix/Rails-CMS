# frozen_string_literal: true

class Urlelement < ContentPart
  def to_s
    if template_element && template_element.html_parts.all.count > 3 then
      template_element.html_parts[0].to_s +
        "<a href=\"#{target_path}\" data-target=\"#{target_path}\" data-position=\"#{position}\" #{template_element.meta} #{data_text}>" +
        template_element.html_parts[1].to_s +
        text +
        template_element.html_parts[2].to_s +
        "</a>" +
        template_element.html_parts[3].to_s.html_safe
    elsif template_element && template_element.html_parts.all.count > 1 then
      template_element.html_parts[0].to_s +
        "<a href=\"#{target_path}\" data-target=\"#{target_path}\" data-position=\"#{position}\" #{template_element.meta} #{data_text}>" +
        text +
        "</a>" +
        template_element.html_parts[1].to_s
    else
      "<a href=\"#{target_path}\" #{data_text}>#{text}</a>".html_safe
    end
  end
end
