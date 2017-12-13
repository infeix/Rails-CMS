# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    msg { Faker::Lorem.word }
    name { Faker::Lorem.word }
    sequence(:email) { |n| "test_email_#{n}@example.com" }
  end
end
