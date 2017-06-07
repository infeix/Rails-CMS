# frozen_string_literal: true

class Service < ActiveRecord::Base
  belongs_to :invoice

  def price_total
    (price_per_unit * amount)
  end
end
