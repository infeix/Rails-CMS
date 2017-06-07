# frozen_string_literal: true

FactoryGirl.define do
  factory :page do
    title { Faker::Lorem.word }
    path  { Faker::Lorem.word }
    text { Faker::Lorem.word }
    template
  end
end
