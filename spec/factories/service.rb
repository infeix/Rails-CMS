# frozen_string_literal: true

FactoryGirl.define do
  factory :service do
    price_per_unit { Faker::Number.number(10) }
    amount { Faker::Number.number(10) }
    unit { Faker::Lorem.word }
    description { Faker::Lorem.word }
    invoice
    is_admin { false }
    sequence(:email) { |n| "test_email_#{n}@example.com" }
    password 'secret42'
    password_confirmation 'secret42'
  end
end
