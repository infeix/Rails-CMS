
class ContentPart < ActiveRecord::Base
  after_save :create_positions

  def create_positions
    Position.create_positions to_s
    Position.create_positions title
  end

  def to_s
    text
  end
end

class Textelement < ContentPart
end

class Urlelement < ContentPart
end

class PdfFile < ContentPart
end

class Picture < ContentPart
end

class Position < ActiveRecord::Base

  def self.create_positions(text)
    return unless text&.include? '{{'
    text_parts = text.split('{{').drop(1)
    text_parts.each do |text_part|
      next unless text_part.include? '}}'
      position_name = text_part.split('}}').first
      Position.find_or_create_by(name: position_name)
    end
  end

  def to_s
    name
  end
end

class CreateNewPositions < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        ContentPart.all.each do |part|
          part.title = part.title.downcase.tr(" ", "_")
          part.save!
        end
      end

      dir.down do
        #
      end
    end
  end
end