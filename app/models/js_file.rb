# frozen_string_literal: true

class JsFile < ContentPart
  def to_s
    "<script src=\"#{js_file.url}\"></script>".html_safe
  end
end
