# frozen_string_literal: true

class Page < ActiveRecord::Base
  belongs_to :template
  has_many :articles, -> { order(index: :asc) }
  validates :path, presence: true

  def render_head
    template.present? ? template.render_head : text
  end

  def render
    template.present? ? template.render(articles.all) : render_articles(articles.all)
  end

  def render_articles(arts)
    html = ''
    arts.each do |article|
      html += article.to_s
    end
    html
  end

  def to_s
    text
  end

  def to_param
    path
  end
end
