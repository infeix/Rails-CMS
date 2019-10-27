# frozen_string_literal: true

class CssFile < ContentPart
  def to_s
    "<link rel=\"stylesheet\" media=\"all\" href=\"#{css_file.url}\">".html_safe
  end
end
