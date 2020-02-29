# frozen_string_literal: true

FactoryBot.define do
  factory :css_part do
    name { Faker::Lorem.word }
    index { Faker::Number.number(10) }
    text { Faker::Lorem.word }
    is_last { false }
    template_element
  end
end
