# frozen_string_literal: true

class Page < ActiveRecord::Base
  belongs_to :template
  has_many :articles
  validates :path, presence: true

  def render
    template.present? ? template.render(articles.all) : text
  end

  def to_s
    text
  end

  def to_param
    path
  end
end
