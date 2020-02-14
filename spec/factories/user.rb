# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end
  factory :user do
    name { Faker::Lorem.word }
    is_admin { true }
    email
    password { 'secret42' }
    password_confirmation { 'secret42' }
  end
end
