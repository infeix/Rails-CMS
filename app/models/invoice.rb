# frozen_string_literal: true

class Invoice < ActiveRecord::Base
  belongs_to :to, class_name: 'Contact'
  belongs_to :from, class_name: 'Contact'
  belongs_to :document_template
  has_many :services

  scope :sort_by_send_date, -> { order(send_date: :asc) }

  def render_pdf
    document_template.render self
  end

  def total
    sum = 0
    services.each do |service|
      sum += service.price_total
    end
    sum
  end

  def tax
    total * 0.19
  end

  def total_with_tax
    total + tax
  end
end
