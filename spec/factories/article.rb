# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Lorem.word }
    text { Faker::Lorem.word }
    code { Faker::Lorem.word }
    index { Faker::Number.number(10) }
    page
  end
end
