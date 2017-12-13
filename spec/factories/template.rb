# frozen_string_literal: true

FactoryBot.define do
  factory :template do
    title { Faker::Lorem.word }
    meta { Faker::Lorem.word }
  end
end
