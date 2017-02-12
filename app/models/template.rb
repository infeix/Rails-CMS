# frozen_string_literal: true

class Template < ActiveRecord::Base
  has_many :articles
end
