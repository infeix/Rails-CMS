# frozen_string_literal: true

class CssFile < ContentPart
  def file_data
    temp_data = ''
    File.open(css_file.current_path, 'r') do |f|
      while line = f.gets
        temp_data += line
      end
    end
    temp_data
  end

  def read_data
    self.data_text = temp_data
    save
  end

  def write_data
    temp_data = self.data_text.gsub "\r\n", "\n"
    temp_data = temp_data.split "\n"
    File.open(css_file.current_path, 'w') do |f|
      while temp_line = temp_data.shift
        f.puts "#{temp_line}\r\n"
      end
    end
    save
  end

  def to_s
    "<link rel=\"stylesheet\" media=\"all\" href=\"#{css_file.url}\">".html_safe
  end
end
