# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { Faker::Lorem.word }
    street { Faker::Lorem.word }
    city { Faker::Lorem.word }
    phone { Faker::Lorem.word }
    sequence(:mail) { |n| "test_mail_#{n}@example.com" }
    bank_account_nr { Faker::Lorem.word }
    bank_name { Faker::Lorem.word }
    tax_nr { Faker::Lorem.word }
  end
end
