# frozen_string_literal: true

FactoryGirl.define do
  factory :template do
    title { Faker::Lorem.word }
    meta { Faker::Lorem.word }
  end
end
