# frozen_string_literal: true

class Urlelement < Article
  def to_s
    "<a href=\"#{target_path}\" #{data_text}>#{text}</a>".html_safe
  end
end
