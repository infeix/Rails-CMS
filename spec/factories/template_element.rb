# frozen_string_literal: true

FactoryBot.define do
  factory :template_element do
    title { Faker::Lorem.word }
    meta { Faker::Lorem.word }
  end
end
