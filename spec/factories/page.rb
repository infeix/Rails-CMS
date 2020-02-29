# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { Faker::Lorem.word }
    path  { Faker::Lorem.word }
    text { Faker::Lorem.word }
    template_element
  end
end
